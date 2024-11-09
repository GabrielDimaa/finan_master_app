import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardTransactionDelete implements ICreditCardTransactionDelete {
  final ICreditCardTransactionRepository _repository;
  final ICreditCardBillRepository _creditCardBillRepository;
  final IExpenseRepository _expenseRepository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardTransactionDelete({
    required ICreditCardTransactionRepository repository,
    required ICreditCardBillRepository creditCardBillRepository,
    required IExpenseRepository expenseRepository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _creditCardBillRepository = creditCardBillRepository,
        _expenseRepository = expenseRepository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<void> delete(CreditCardTransactionEntity entity) async {
    final CreditCardBillEntity? bill = await _creditCardBillRepository.findById(entity.idCreditCardBill!);

    //Não é possível excluir uma transação de uma fatura paga
    if (bill?.paid == true) throw ValidationException(R.strings.notPossibleDeleteTransactionCreditCardPaid);

    await _delete([entity]);
  }

  @override
  Future<void> deleteMany(List<CreditCardTransactionEntity> entities) => _delete(entities);

  Future<void> _delete(List<CreditCardTransactionEntity> entities) async {
    final List<CreditCardBillEntity> bills = await _creditCardBillRepository.findByIds(groupBy(entities, (entity) => entity.idCreditCardBill ?? '').keys.toList());
    if (bills.any((bill) => bill.paid)) throw ValidationException(R.strings.notPossibleDeleteTransactionCreditCardPaid);

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
