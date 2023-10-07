import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';

abstract interface class ITransactionRepository {
  Future<TransactionsByPeriodEntity> findByPeriod(DateTime startDate, DateTime endDate);
}