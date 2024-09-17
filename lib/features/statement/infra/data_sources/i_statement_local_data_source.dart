import 'package:finan_master_app/features/statement/infra/models/statement_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class IStatementLocalDataSource implements ILocalDataSource<StatementModel> {
  Future<void> deleteByIdExpense(String id, {ITransactionExecutor? txn});

  Future<void> deleteByIdIncome(String id, {ITransactionExecutor? txn});

  Future<void> deleteByIdTransfer(String id, {ITransactionExecutor? txn});

  Future<List<Map<String, dynamic>>> findMonthlyBalances({required DateTime startDate, required DateTime endDate});
}
