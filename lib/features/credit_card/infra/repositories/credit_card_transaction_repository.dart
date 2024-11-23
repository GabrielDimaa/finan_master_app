import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/features/statement/infra/data_sources/i_statement_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class CreditCardTransactionRepository implements ICreditCardTransactionRepository {
  final ICreditCardTransactionLocalDataSource _dataSource;
  final IDatabaseLocalTransaction _dbTransaction;
  final EventNotifier _eventNotifier;

  CreditCardTransactionRepository({
    required ICreditCardTransactionLocalDataSource dataSource,
    required IExpenseLocalDataSource expenseDataSource,
    required IStatementLocalDataSource statementDataSource,
    required IDatabaseLocalTransaction dbTransaction,
    required EventNotifier eventNotifier,
  })  : _dataSource = dataSource,
        _dbTransaction = dbTransaction,
        _eventNotifier = eventNotifier;

  @override
  Future<CreditCardTransactionEntity?> findById(String id, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      return await _dbTransaction.openTransaction((newTxn) => findById(id, txn: newTxn));
    }

    final CreditCardTransactionModel? result = await _dataSource.findOne(where: '${Model.idColumnName} = ?', whereArgs: [id], txn: txn);

    return result != null ? CreditCardTransactionFactory.toEntity(result) : null;
  }

  @override
  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity, {ITransactionExecutor? txn}) async {
    final CreditCardTransactionModel transaction = await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.creditCard);

    return CreditCardTransactionFactory.toEntity(transaction);
  }

  @override
  Future<void> saveMany(List<CreditCardTransactionEntity> transactions, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((newTxn) => saveMany(transactions, txn: newTxn));
      return;
    }

    for (final transaction in transactions) {
      await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(transaction), txn: txn);
    }

    _eventNotifier.notify(EventType.creditCard);
  }

  @override
  Future<void> delete(CreditCardTransactionEntity entity, {ITransactionExecutor? txn}) async {
    await _dataSource.delete(CreditCardTransactionFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.creditCard);
  }

  @override
  Future<void> deleteMany(List<CreditCardTransactionEntity> entities, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      return await _dbTransaction.openTransaction((newTxn) => deleteMany(entities, txn: newTxn));
    }

    for (final entity in entities) {
      await delete(entity, txn: txn);
    }

    _eventNotifier.notify(EventType.creditCard);
  }
}
