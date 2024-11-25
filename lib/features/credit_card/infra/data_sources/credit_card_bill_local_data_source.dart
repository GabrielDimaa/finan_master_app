import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_bill_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardBillLocalDataSource extends LocalDataSource<CreditCardBillModel> implements ICreditCardBillLocalDataSource {
  CreditCardBillLocalDataSource({
    required super.databaseLocal,
    required ICreditCardTransactionLocalDataSource creditCardTransactionLocalDataSource,
  }) : super(childrenRepositories: [creditCardTransactionLocalDataSource]);

  ICreditCardTransactionLocalDataSource get creditCardTransactionLocalDataSource => childrenRepositories.firstWhere((child) => child is ICreditCardTransactionLocalDataSource) as ICreditCardTransactionLocalDataSource;

  @override
  String get tableName => creditCardBillsTableName;

  @override
  String get orderByDefault => '$tableName.bill_closing_date ASC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        bill_closing_date TEXT NOT NULL,
        bill_due_date TEXT NOT NULL,
        id_credit_card TEXT NOT NULL REFERENCES $creditCardsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT
      );
    ''');
  }

  @override
  CreditCardBillModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return CreditCardBillModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      billClosingDate: DateTime.tryParse(map['${prefix}bill_closing_date'].toString())!.toLocal(),
      billDueDate: DateTime.tryParse(map['${prefix}bill_due_date'].toString())!.toLocal(),
      idCreditCard: map['${prefix}id_credit_card'],
      transactions: []
    );
  }

  @override
  Future<List<CreditCardBillModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, String? groupBy, ITransactionExecutor? txn}) async {
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
        WITH bills_with_total_amount AS (
          SELECT
            $tableName.*,
            SUM(${creditCardTransactionLocalDataSource.tableName}.amount) AS total_amount
          FROM $tableName
          LEFT JOIN ${creditCardTransactionLocalDataSource.tableName}
            ON $tableName.${Model.idColumnName} = ${creditCardTransactionLocalDataSource.tableName}.id_credit_card_bill AND ${creditCardTransactionLocalDataSource.tableName}.${Model.deletedAtColumnName} IS NULL
          GROUP BY ${groupBy ?? '$tableName.${Model.idColumnName}'}
        )
        SELECT
          -- Bills
          $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
          $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
          $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
          $tableName.bill_closing_date AS ${tableName}_bill_closing_date,
          $tableName.bill_due_date AS ${tableName}_bill_due_date,
          $tableName.id_credit_card AS ${tableName}_id_credit_card,
          
          -- Transactions
          ${creditCardTransactionLocalDataSource.tableName}.${Model.idColumnName} AS ${creditCardTransactionLocalDataSource.tableName}_${Model.idColumnName},
          ${creditCardTransactionLocalDataSource.tableName}.${Model.createdAtColumnName} AS ${creditCardTransactionLocalDataSource.tableName}_${Model.createdAtColumnName},
          ${creditCardTransactionLocalDataSource.tableName}.${Model.deletedAtColumnName} AS ${creditCardTransactionLocalDataSource.tableName}_${Model.deletedAtColumnName},
          ${creditCardTransactionLocalDataSource.tableName}.description AS ${creditCardTransactionLocalDataSource.tableName}_description,
          ${creditCardTransactionLocalDataSource.tableName}.amount AS ${creditCardTransactionLocalDataSource.tableName}_amount,
          ${creditCardTransactionLocalDataSource.tableName}.date AS ${creditCardTransactionLocalDataSource.tableName}_date,
          ${creditCardTransactionLocalDataSource.tableName}.id_category AS ${creditCardTransactionLocalDataSource.tableName}_id_category,
          ${creditCardTransactionLocalDataSource.tableName}.id_credit_card AS ${creditCardTransactionLocalDataSource.tableName}_id_credit_card,
          ${creditCardTransactionLocalDataSource.tableName}.id_credit_card_bill AS ${creditCardTransactionLocalDataSource.tableName}_id_credit_card_bill,
          ${creditCardTransactionLocalDataSource.tableName}.observation AS ${creditCardTransactionLocalDataSource.tableName}_observation
        FROM (
          SELECT $tableName.*
          FROM bills_with_total_amount AS $tableName
          ${whereListed.isNotEmpty ? 'WHERE ${whereListed.join(' AND ')}' : ''}
          ${groupBy?.isNotEmpty == true ? 'GROUP BY $groupBy' : ''}
          ORDER BY ${orderBy ?? orderByDefault}
          ${limit != null ? ' LIMIT $limit' : ''}
          ${offset != null ? ' OFFSET $offset' : ''}
        ) AS $tableName
        INNER JOIN credit_cards
          ON $tableName.id_credit_card = credit_cards.${Model.idColumnName}
        LEFT JOIN ${creditCardTransactionLocalDataSource.tableName}
          ON $tableName.${Model.idColumnName} = ${creditCardTransactionLocalDataSource.tableName}.id_credit_card_bill AND ${creditCardTransactionLocalDataSource.tableName}.${Model.deletedAtColumnName} IS NULL
        ORDER BY $tableName.bill_closing_date, ${creditCardTransactionLocalDataSource.tableName}.date DESC;
      ''';

      final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).raw(sql, DatabaseOperation.select, whereArgs);

      final List<CreditCardBillModel> bills = [];

      for (final result in results) {
        CreditCardBillModel? bill = bills.firstWhereOrNull((c) => c.id == result['${tableName}_${Model.idColumnName}']);

        if (bill == null) {
          bill = fromMap(result, prefix: '${tableName}_');
          bills.add(bill);
        }

        if (result['${creditCardTransactionLocalDataSource.tableName}_${Model.idColumnName}'] != null) {
          if (!bill.transactions.any((s) => s.id == result['${creditCardTransactionLocalDataSource.tableName}_${Model.idColumnName}'])) {
            bill.transactions.add(creditCardTransactionLocalDataSource.fromMap(result, prefix: '${creditCardTransactionLocalDataSource.tableName}_'));
          }
        }
      }

      return bills;
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }
}
