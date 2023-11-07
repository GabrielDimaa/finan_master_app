import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';

abstract interface class ITransactionFind {
  Future<TransactionsByPeriodEntity> findByPeriod(DateTime startDate, DateTime endDate);

  Future<List<ITransactionEntity>> findByText({required CategoryTypeEnum categoryType, required String text});
}
