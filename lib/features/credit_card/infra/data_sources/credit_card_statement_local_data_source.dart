import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_statement_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardStatementLocalDataSource extends LocalDataSource<CreditCardStatementModel> implements ICreditCardStatementLocalDataSource {
  CreditCardStatementLocalDataSource({
    required super.databaseLocal,
    required ICreditCardTransactionLocalDataSource creditCardTransactionLocalDataSource,
  }) : super(childrenRepositories: [creditCardTransactionLocalDataSource]);

  ICreditCardTransactionLocalDataSource get creditCardTransactionLocalDataSource => childrenRepositories.firstWhere((child) => child is ICreditCardTransactionLocalDataSource) as ICreditCardTransactionLocalDataSource;

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
      amountLimit: map['${prefix}amount_limit'],
      transactions: [],
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
        whereListed.add('$tableName.${Model.idColumnName} = ?');
        whereArgs.add(id);
      }

      if (!deleted) {
        whereListed.add('$tableName.${Model.deletedAtColumnName} IS NULL');
      }

      final String sql = '''
        SELECT
          -- Statements
          $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
          $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
          $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
          $tableName.statement_closing_date AS ${tableName}_statement_closing_date,
          $tableName.statement_due_date AS ${tableName}_statement_due_date,
          $tableName.id_credit_card AS ${tableName}_id_credit_card,
          
          -- Credit Card
          credit_cards.amount_limit AS ${tableName}_amount_limit,
          
          -- Transactions
          ${creditCardTransactionLocalDataSource.tableName}.${Model.idColumnName} AS ${creditCardTransactionLocalDataSource.tableName}_${Model.idColumnName},
          ${creditCardTransactionLocalDataSource.tableName}.${Model.createdAtColumnName} AS ${creditCardTransactionLocalDataSource.tableName}_${Model.createdAtColumnName},
          ${creditCardTransactionLocalDataSource.tableName}.${Model.deletedAtColumnName} AS ${creditCardTransactionLocalDataSource.tableName}_${Model.deletedAtColumnName},
          ${creditCardTransactionLocalDataSource.tableName}.description AS ${creditCardTransactionLocalDataSource.tableName}_description,
          ${creditCardTransactionLocalDataSource.tableName}.amount AS ${creditCardTransactionLocalDataSource.tableName}_amount,
          ${creditCardTransactionLocalDataSource.tableName}.date AS ${creditCardTransactionLocalDataSource.tableName}_date,
          ${creditCardTransactionLocalDataSource.tableName}.id_category AS ${creditCardTransactionLocalDataSource.tableName}_id_category,
          ${creditCardTransactionLocalDataSource.tableName}.id_credit_card AS ${creditCardTransactionLocalDataSource.tableName}_id_credit_card,
          ${creditCardTransactionLocalDataSource.tableName}.id_credit_card_statement AS ${creditCardTransactionLocalDataSource.tableName}_id_credit_card_statement,
          ${creditCardTransactionLocalDataSource.tableName}.observation AS ${creditCardTransactionLocalDataSource.tableName}_observation
        FROM (
          SELECT $tableName.*
          FROM $tableName
          ${whereListed.isNotEmpty ? 'WHERE ${whereListed.join(' AND ')}' : ''}
          ORDER BY ${orderBy ?? orderByDefault}
          ${limit != null ? ' LIMIT $limit' : ''}
          ${offset != null ? ' OFFSET $offset' : ''}
        ) AS $tableName
        INNER JOIN credit_cards
          ON $tableName.id_credit_card = credit_cards.id
        LEFT JOIN ${creditCardTransactionLocalDataSource.tableName}
          ON $tableName.id = ${creditCardTransactionLocalDataSource.tableName}.id_credit_card_statement AND ${creditCardTransactionLocalDataSource.tableName}.${Model.deletedAtColumnName} IS NULL;
      ''';

      final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).raw(sql, DatabaseOperation.select, whereArgs);

      final List<CreditCardStatementModel> statements = [];

      for (final result in results) {
        CreditCardStatementModel? statement = statements.firstWhereOrNull((c) => c.id == result['${tableName}_${Model.idColumnName}']);

        if (statement == null) {
          statement = fromMap(result, prefix: '${tableName}_');
          statements.add(statement);
        }

        if (result['${creditCardTransactionLocalDataSource.tableName}_${Model.idColumnName}'] != null) {
          if (!statement.transactions.any((s) => s.id == result['${creditCardTransactionLocalDataSource.tableName}_${Model.idColumnName}'])) {
            statement.transactions.add(creditCardTransactionLocalDataSource.fromMap(result, prefix: '${creditCardTransactionLocalDataSource.tableName}_'));
          }
        }
      }

      return statements;
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }
}
