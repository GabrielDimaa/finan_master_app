import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/financial_operation.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/i_financial_operation_model.dart';

class TransactionRepository implements ITransactionRepository {
  final ITransactionLocalDataSource _transactionDataSource;

  TransactionRepository({required ITransactionLocalDataSource transactionDataSource}) : _transactionDataSource = transactionDataSource;

  @override
  Future<List<IFinancialOperationEntity>> findByPeriod(DateTime startDate, DateTime endDate) async {
    final List<IFinancialOperationModel> models = await _transactionDataSource.findFinancialOperations(startDate: startDate, endDate: endDate);
    return models.map((model) => FinancialOperationFactory.toEntity(model)).toList();
  }
}
