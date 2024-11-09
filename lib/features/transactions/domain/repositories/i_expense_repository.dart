import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class IExpenseRepository {
  Future<ExpenseEntity> save(ExpenseEntity entity, {ITransactionExecutor? txn});

  Future<void> delete(ExpenseEntity entity, {ITransactionExecutor? txn});

  Future<void> deleteMany(List<ExpenseEntity> entities, {ITransactionExecutor? txn});

  Future<List<ExpenseEntity>> findByPeriod(DateTime startDate, DateTime endDate);

  Future<List<TransactionByTextEntity>> findByText(String text);

  Future<List<ExpenseEntity>> findByIdCreditCardTransaction(List<String> ids);
}
