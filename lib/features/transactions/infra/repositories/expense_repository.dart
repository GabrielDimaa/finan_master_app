import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/expense_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class ExpenseRepository implements IExpenseRepository {
  final IDatabaseLocalTransaction _dbTransaction;
  final IExpenseLocalDataSource _expenseLocalDataSource;
  final ITransactionLocalDataSource _transactionLocalDataSource;
  final EventNotifier _eventNotifier;

  ExpenseRepository({
    required IDatabaseLocalTransaction dbTransaction,
    required IExpenseLocalDataSource expenseLocalDataSource,
    required ITransactionLocalDataSource transactionLocalDataSource,
    required EventNotifier eventNotifier,
  })  : _dbTransaction = dbTransaction,
        _expenseLocalDataSource = expenseLocalDataSource,
        _transactionLocalDataSource = transactionLocalDataSource,
        _eventNotifier = eventNotifier;

  @override
  Future<ExpenseEntity> save(ExpenseEntity entity, {ITransactionExecutor? txn}) async {
    if (txn == null) return await _dbTransaction.openTransaction<ExpenseEntity>((txn) => save(entity, txn: txn));

    final ExpenseModel model = ExpenseFactory.fromEntity(entity);

    model.transaction = await _transactionLocalDataSource.upsert(model.transaction, txn: txn);
    final ExpenseModel result = await _expenseLocalDataSource.upsert(model, txn: txn);

    _eventNotifier.notify(EventType.transactions);

    return ExpenseFactory.toEntity(result);
  }

  @override
  Future<void> delete(ExpenseEntity entity, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction<void>((txn) => delete(entity, txn: txn));
      return;
    }

    final ExpenseModel model = ExpenseFactory.fromEntity(entity);

    await _expenseLocalDataSource.delete(model, txn: txn);
    await _transactionLocalDataSource.delete(model.transaction, txn: txn);

    _eventNotifier.notify(EventType.transactions);
  }
}
