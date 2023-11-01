import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class CreditCardTransactionRepository implements ICreditCardTransactionRepository {
  final ICreditCardTransactionLocalDataSource _dataSource;
  final IExpenseLocalDataSource _expenseDataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  CreditCardTransactionRepository({
    required ICreditCardTransactionLocalDataSource dataSource,
    required IExpenseLocalDataSource expenseDataSource,
    required IDatabaseLocalTransaction dbTransaction,
  })  : _dataSource = dataSource,
        _expenseDataSource = expenseDataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity, {ITransactionExecutor? txn}) async {
    final CreditCardTransactionModel transaction = await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(entity), txn: txn);
    return CreditCardTransactionFactory.toEntity(transaction);
  }

  @override
  Future<void> saveMany(List<CreditCardTransactionEntity> transactions, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((newTxn) async {
        for (final transaction in transactions) {
          await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(transaction), txn: newTxn);
        }
      });
    } else {
      for (final transaction in transactions) {
        await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(transaction), txn: txn);
      }
    }
  }

  @override
  Future<void> delete(CreditCardTransactionEntity entity, {ITransactionExecutor? txn}) async {
    final ExpenseModel? expenseModel = await _expenseDataSource.findOne(where: '${_expenseDataSource.tableName}_id_credit_card_transaction = ?', whereArgs: [entity.id], txn: txn);

    if (txn != null) {
      if (expenseModel != null) await _expenseDataSource.delete(expenseModel, txn: txn);

      await _dataSource.delete(CreditCardTransactionFactory.fromEntity(entity), txn: txn);
    } else {
      await _dbTransaction.openTransaction((txn) async {
        if (expenseModel != null) await _expenseDataSource.delete(expenseModel, txn: txn);

        await _dataSource.delete(CreditCardTransactionFactory.fromEntity(entity), txn: txn);
      });
    }
  }

  @override
  Future<void> deleteMany(List<CreditCardTransactionEntity> entities) async {
    await _dbTransaction.openTransaction((txn) async {
      for (final entity in entities) {
        await delete(entity, txn: txn);
      }
    });
  }
}
