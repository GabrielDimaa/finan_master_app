import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';

class ExpenseDelete implements IExpenseDelete {
  final IExpenseRepository _repository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  ExpenseDelete({
    required IExpenseRepository repository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<void> delete(ExpenseEntity entity) async {
    await _localDBTransactionRepository.openTransaction((txn) async {
      await Future.wait([
        _repository.delete(entity, txn: txn),
        _statementRepository.deleteByIdExpense(entity.id, txn: txn),
      ]);
    });
  }
}
