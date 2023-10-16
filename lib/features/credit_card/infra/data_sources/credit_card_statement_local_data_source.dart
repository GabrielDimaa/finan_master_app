import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_statement_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardStatementLocalDataSource extends LocalDataSource<CreditCardStatementModel> implements ICreditCardStatementLocalDataSource {
  CreditCardStatementLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => 'credit_card_statements';

  @override
  String get orderByDefault => '$tableName.statement_closing_date ASC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        statement_closing_date TEXT NOT NULL,
        statement_due_date TEXT NOT NULL,
        id_credit_card TEXT NOT NULL REFERENCES credit_cards(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT
      );
    ''');
  }

  @override
  CreditCardStatementModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return CreditCardStatementModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      statementClosingDate: DateTime.tryParse(map['${prefix}statement_closing_date'].toString())!.toLocal(),
      statementDueDate: DateTime.tryParse(map['${prefix}statement_due_date'].toString())!.toLocal(),
      idCreditCard: map['${prefix}id_credit_card'],
      statementAmount: map['${prefix}statement_amount'],
      amountLimit: map['${prefix}amount_limit'],
    );
  }

  @override
  Future<List<CreditCardStatementModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, ITransactionExecutor? txn}) async {
    try {
      List<String> whereListed = [];
      whereArgs ??= [];

      if (where?.isNotEmpty == true) {
        whereListed.add(where!);
      }

      if (id != null) {
        whereListed.add('${Model.idColumnName} = ?');
        whereArgs.add(id);
      }

      if (!deleted) {
        whereListed.add('$tableName.${Model.deletedAtColumnName} IS NULL');
      }

      whereListed.add('credit_card_transactions.${Model.deletedAtColumnName} IS NULL');

      final String sql = '''
        SELECT
          $tableName.*,
          credit_cards.amount_limit as amount_limit,
          COALESCE(SUM(credit_card_transactions.amount), 0.0) as statement_amount
        FROM $tableName
        INNER JOIN credit_cards
          ON $tableName.id_credit_card = credit_cards.id
        LEFT JOIN credit_card_transactions
          ON $tableName.id = credit_card_transactions.id_credit_card_statement
        ${whereListed.isNotEmpty ? 'WHERE ${whereListed.join(' AND ')}' : ''}
        GROUP BY $tableName.${Model.idColumnName}
        ORDER BY ${orderBy ?? orderByDefault}
        ${limit != null ? ' LIMIT $limit' : ''}
        ${offset != null ? ' OFFSET $offset' : ''};
      ''';

      final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).raw(sql, DatabaseOperation.select, whereArgs);

      return results.map((e) => fromMap(e)).toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }
}
