import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/expense_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_by_text_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class ExpenseRepository implements IExpenseRepository {
  final IExpenseLocalDataSource _expenseLocalDataSource;
  final IDatabaseLocalTransaction _dbTransaction;
  final EventNotifier _eventNotifier;

  ExpenseRepository({
    required IExpenseLocalDataSource expenseLocalDataSource,
    required IDatabaseLocalTransaction dbTransaction,
    required EventNotifier eventNotifier,
  })  : _expenseLocalDataSource = expenseLocalDataSource,
        _dbTransaction = dbTransaction,
        _eventNotifier = eventNotifier;

  @override
  Future<ExpenseEntity> save(ExpenseEntity entity, {ITransactionExecutor? txn}) async {
    final ExpenseModel result = await _expenseLocalDataSource.upsert(ExpenseFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.expense);

    return ExpenseFactory.toEntity(result);
  }

  @override
  Future<void> delete(ExpenseEntity entity, {ITransactionExecutor? txn}) async {
    await _expenseLocalDataSource.delete(ExpenseFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.expense);
  }

  @override
  Future<void> deleteMany(List<ExpenseEntity> entities, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((newTxn) => deleteMany(entities, txn: newTxn));
      return;
    }

    for (final entity in entities) {
      await delete(entity, txn: txn);
    }
  }

  @override
  Future<List<ExpenseEntity>> findByPeriod(DateTime startDate, DateTime endDate) async {
    final List<ExpenseModel> models = await _expenseLocalDataSource.findAll(where: 'date >= ? AND date <= ?', whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()]);

    return models.map((model) => ExpenseFactory.toEntity(model)).toList();
  }

  @override
  Future<List<TransactionByTextEntity>> findByText(String text) async {
    final List<TransactionByTextModel> models = await _expenseLocalDataSource.findByText(text);

    return models
        .map((model) => TransactionByTextEntity(
              description: model.description,
              idCategory: model.idCategory,
              idAccount: model.idAccount,
              idCreditCard: model.idCreditCard,
              observation: model.observation,
            ))
        .toList();
  }

  @override
  Future<List<ExpenseEntity>> findByIdCreditCardTransaction(List<String> ids) async {
    final List<ExpenseModel> models = await _expenseLocalDataSource.findAll(where: 'id_credit_card_transaction in (${ids.map((e) => '?').join(', ')})', whereArgs: ids);

    return models.map((model) => ExpenseFactory.toEntity(model)).toList();
  }
}
