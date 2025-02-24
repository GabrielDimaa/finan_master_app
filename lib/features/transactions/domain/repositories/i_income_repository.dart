import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class IIncomeRepository {
  Future<IncomeEntity> save(IncomeEntity entity, {ITransactionExecutor? txn});

  Future<void> delete(IncomeEntity entity, {ITransactionExecutor? txn});

  Future<List<IncomeEntity>> findByPeriod(DateTime startDate, DateTime endDate);

  Future<List<TransactionByTextEntity>> findByText(String text);
}
