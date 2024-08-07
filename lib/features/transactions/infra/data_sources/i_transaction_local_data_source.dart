import 'package:finan_master_app/features/transactions/infra/models/i_transaction_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class ITransactionLocalDataSource implements ILocalDataSource<TransactionModel> {
  Future<List<ITransactionModel>> findByPeriod({required DateTime startDate, required DateTime endDate});

  Future<List<ITransactionModel>> findIncomeByText(String text);

  Future<List<ITransactionModel>> findExpenseByText(String text);

  Future<List<Map<String, dynamic>>> findMonthlyBalances({required DateTime startDate, required DateTime endDate});
}
