import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';

class CreditCardTransactionDelete implements ICreditCardTransactionDelete {
  final ICreditCardTransactionRepository _repository;
  final IExpenseRepository _expenseRepository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardTransactionDelete({
    required ICreditCardTransactionRepository repository,
    required IExpenseRepository expenseRepository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _expenseRepository = expenseRepository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<void> delete(CreditCardTransactionEntity entity) => _delete([entity]);

  @override
  Future<void> deleteMany(List<CreditCardTransactionEntity> entities) => _delete(entities);

  Future<void> _delete(List<CreditCardTransactionEntity> entities) async {
    final List<ExpenseEntity> expenses = await _expenseRepository.findByIdCreditCardTransaction(entities.map((e) => e.id).toList());

    await _localDBTransactionRepository.openTransaction((txn) async {
      await Future.wait([
        _repository.deleteMany(entities, txn: txn),
        _expenseRepository.deleteMany(expenses, txn: txn),
        _statementRepository.deleteByIdsExpense(expenses.map((e) => e.id).toList(), txn: txn),
      ]);
    });
  }
}
