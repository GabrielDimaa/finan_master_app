import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/financial_operation.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/i_transaction_model.dart';

class TransactionRepository implements ITransactionRepository {
  final ITransactionLocalDataSource _transactionDataSource;

  TransactionRepository({required ITransactionLocalDataSource transactionDataSource}) : _transactionDataSource = transactionDataSource;

  @override
  Future<TransactionsByPeriodEntity> findByPeriod(DateTime startDate, DateTime endDate) async {
    final List<ITransactionModel> models = await _transactionDataSource.findByPeriod(startDate: startDate, endDate: endDate);
    return TransactionsByPeriodEntity(transactions: models.map((model) => FinancialOperationFactory.toEntity(model)).toList());
  }
}
