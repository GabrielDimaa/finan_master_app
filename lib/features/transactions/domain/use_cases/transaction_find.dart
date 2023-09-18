import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';

class TransactionFind implements ITransactionFind {
  final ITransactionRepository _repository;

  TransactionFind({required ITransactionRepository repository}) : _repository = repository;

  @override
  Future<List<IFinancialOperationEntity>> findByPeriod(DateTime startDate, DateTime endDate) => _repository.findByPeriod(startDate, endDate);
}
