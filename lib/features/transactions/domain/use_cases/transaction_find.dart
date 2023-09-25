import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';

class TransactionFind implements ITransactionFind {
  final ITransactionRepository _repository;

  TransactionFind({required ITransactionRepository repository}) : _repository = repository;

  @override
  Future<TransactionsByPeriodEntity> findByPeriod(DateTime startDate, DateTime endDate) => _repository.findByPeriod(startDate, endDate);
}
