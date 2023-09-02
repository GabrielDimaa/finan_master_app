import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/expense_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class ExpenseRepository implements IExpenseRepository {
  final IDatabaseLocalTransaction _dbTransaction;
  final IExpenseLocalDataSource _expenseLocalDataSource;
  final ITransactionLocalDataSource _transactionLocalDataSource;

  ExpenseRepository({
    required IDatabaseLocalTransaction dbTrasanction,
    required IExpenseLocalDataSource expenseLocalDataSource,
    required ITransactionLocalDataSource transactionLocalDataSource,
  })  : _dbTransaction = dbTrasanction,
        _expenseLocalDataSource = expenseLocalDataSource,
        _transactionLocalDataSource = transactionLocalDataSource;

  @override
  Future<ExpenseEntity> save(ExpenseEntity entity) async {
    final ExpenseModel model = ExpenseFactory.fromEntity(entity);

    late final ExpenseModel expenseResult;
    late final TransactionModel transactionResult;

    await _dbTransaction.openTransaction((txn) async {
      Future.wait([
        Future.value(() async => transactionResult = await _transactionLocalDataSource.upsert(model.transaction)),
        Future.value(() async => expenseResult = await _expenseLocalDataSource.upsert(model)),
      ]);
    });

    expenseResult.transaction = transactionResult;

    return ExpenseFactory.toEntity(expenseResult);
  }
}
