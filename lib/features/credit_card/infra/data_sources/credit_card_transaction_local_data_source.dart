import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardTransactionLocalDataSource extends LocalDataSource<CreditCardTransactionModel> implements ICreditCardTransactionLocalDataSource {
  CreditCardTransactionLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => creditCardTransactionsTableName;

  @override
  String get orderByDefault => 'date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        id_category TEXT NOT NULL REFERENCES $categoriesTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_credit_card TEXT NOT NULL REFERENCES $creditCardsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_credit_card_bill TEXT REFERENCES $creditCardBillsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        observation TEXT
      );
    ''');
  }

  @override
  CreditCardTransactionModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return CreditCardTransactionModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      amount: map['${prefix}amount'],
      date: DateTime.tryParse(map['${prefix}date'].toString())!.toLocal(),
      idCategory: map['${prefix}id_category'],
      idCreditCard: map['${prefix}id_credit_card'],
      idCreditCardBill: map['${prefix}id_credit_card_bill'],
      observation: map['${prefix}observation'],
    );
  }

  @override
  Future<List<CreditCardTransactionModel>> findByPeriod({required DateTime? startDate, required DateTime? endDate, bool onlyPaid = false, bool ignoreBillPayment = false}) async {
    try {
      final List<String> where = [];
      final List<dynamic> whereArgs = [];

      if (startDate != null) {
        where.add('$tableName.date >= ?');
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        where.add('$tableName.date <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      if (onlyPaid) {
        where.add('bills_with_total_amount.total_amount <= ?');
        whereArgs.add(0);
      }

      if (ignoreBillPayment) {
        where.add('$tableName.amount > ?');
        whereArgs.add(0);
      }

      final String sql = '''
        WITH bills_with_total_amount AS (
          SELECT
            $creditCardBillsTableName.${Model.idColumnName},
            $creditCardBillsTableName.${Model.createdAtColumnName},
            $creditCardBillsTableName.${Model.deletedAtColumnName},
            $creditCardBillsTableName.bill_closing_date,
            $creditCardBillsTableName.bill_due_date,
            $creditCardBillsTableName.id_credit_card,
            ROUND(SUM($tableName.amount)) AS total_amount
          FROM $creditCardBillsTableName
          LEFT JOIN $tableName
            ON $tableName.id_credit_card_bill = $creditCardBillsTableName.${Model.idColumnName} AND $tableName.${Model.deletedAtColumnName} IS NULL
          GROUP BY $creditCardBillsTableName.${Model.idColumnName}
        )
        SELECT
          $tableName.${Model.idColumnName},
          $tableName.${Model.createdAtColumnName},
          $tableName.${Model.deletedAtColumnName},
          $tableName.description,
          $tableName.amount,
          $tableName.date,
          $tableName.id_category,
          $tableName.id_credit_card,
          $tableName.id_credit_card_bill,
          $tableName.observation,
        FROM $tableName
        INNER JOIN bills_with_total_amount
          ON bills_with_total_amount.${Model.idColumnName} = $tableName.id_credit_card_bill
        WHERE $tableName.${Model.deletedAtColumnName} IS NULL AND ${where.join(' AND ')}
        ORDER BY $orderByDefault
      ''';

      final List<Map<String, dynamic>> result = await databaseLocal.raw(sql, DatabaseOperation.select, whereArgs);

      return result.map((e) => fromMap(e)).toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }
}
