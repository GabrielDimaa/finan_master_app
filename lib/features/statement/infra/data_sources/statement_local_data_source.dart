import 'package:finan_master_app/features/statement/infra/data_sources/i_statement_local_data_source.dart';
import 'package:finan_master_app/features/statement/infra/models/statement_model.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class StatementLocalDataSource extends LocalDataSource<StatementModel> implements IStatementLocalDataSource {
  StatementLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => statementsTableName;

  @override
  String get orderByDefault => '${tableName}_date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        id_account TEXT NOT NULL REFERENCES $accountsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_expense TEXT REFERENCES $expensesTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_income TEXT REFERENCES $incomesTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_transfer TEXT REFERENCES $transfersTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT
      );
    ''');
  }

  @override
  StatementModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return StatementModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      amount: map['${prefix}amount'],
      date: DateTime.tryParse(map['${prefix}date'].toString())!.toLocal(),
      idAccount: map['${prefix}id_account'],
      idExpense: map['${prefix}id_expense'],
      idIncome: map['${prefix}id_income'],
      idTransfer: map['${prefix}id_transfer'],
    );
  }

  @override
  Future<void> deleteByIdExpense(String id, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await databaseLocal.transactionInstance().openTransaction((newTxn) => deleteByIdExpense(id, txn: newTxn));

      return;
    }

    await txn.delete(tableName, where: 'id_expense = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteByIdIncome(String id, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await databaseLocal.transactionInstance().openTransaction((newTxn) => deleteByIdIncome(id, txn: newTxn));

      return;
    }

    await txn.delete(tableName, where: 'id_income = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteByIdTransfer(String id, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await databaseLocal.transactionInstance().openTransaction((newTxn) => deleteByIdTransfer(id, txn: newTxn));

      return;
    }

    await txn.delete(tableName, where: 'id_transfer = ?', whereArgs: [id]);
  }

  @override
  Future<List<Map<String, dynamic>>> findMonthlyBalances({required DateTime startDate, required DateTime endDate}) async {
    try {
      startDate = startDate.getInitialMonth();
      endDate = endDate.getFinalMonth();

      const String sql = '''
        SELECT
          STRFTIME('%Y-%m-01', date) AS month,
          ROUND(SUM(amount), 2) AS monthly_sum
        FROM $statementsTableName
        WHERE
          date BETWEEN ? AND ? AND
          ${Model.deletedAtColumnName} IS NULL
        GROUP BY month;
      ''';

      return await databaseLocal.raw(sql, DatabaseOperation.select, [startDate.toIso8601String(), endDate.toIso8601String()]);
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }
}
