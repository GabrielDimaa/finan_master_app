import 'package:finan_master_app/features/transactions/infra/models/i_financial_operation_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class ITransactionLocalDataSource implements ILocalDataSource<TransactionModel> {
  Future<List<IFinancialOperationModel>> findFinancialOperations({required DateTime startDate, required DateTime endDate});
}
