import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/expense_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class ExpenseRepository implements IExpenseRepository {
  final IDatabaseLocalTransaction _dbTransaction;
  final IExpenseLocalDataSource _expenseLocalDataSource;
  final ITransactionLocalDataSource _transactionLocalDataSource;

  ExpenseRepository({
    required IDatabaseLocalTransaction dbTransaction,
    required IExpenseLocalDataSource expenseLocalDataSource,
    required ITransactionLocalDataSource transactionLocalDataSource,
  })  : _dbTransaction = dbTransaction,
        _expenseLocalDataSource = expenseLocalDataSource,
        _transactionLocalDataSource = transactionLocalDataSource;

  @override
  Future<ExpenseEntity> save(ExpenseEntity entity) async {
    final ExpenseModel model = ExpenseFactory.fromEntity(entity);

    final ExpenseModel result = await _dbTransaction.openTransaction<ExpenseModel>((txn) async {
      model.transaction = await _transactionLocalDataSource.upsert(model.transaction, txn: txn);
      return await _expenseLocalDataSource.upsert(model, txn: txn);
    });

    return ExpenseFactory.toEntity(result);
  }

  @override
  Future<List<ExpenseEntity>> findByPeriod(DateTime start, DateTime end) async {
    final List<ExpenseModel> result = await _expenseLocalDataSource.findByPeriod(start, end);
    return result.map((e) => ExpenseFactory.toEntity(e)).toList();
  }
}
