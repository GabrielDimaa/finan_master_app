import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation_entity.dart';

abstract interface class ITransactionFind {
  Future<List<IFinancialOperationEntity>> findByPeriod(DateTime startDate, DateTime endDate);
}
