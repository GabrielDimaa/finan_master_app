import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_save.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/statement/helpers/statement_factory.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardBillSave implements ICreditCardBillSave {
  final ICreditCardTransactionRepository _creditCardTransactionRepository;
  final ICreditCardRepository _creditCardRepository;
  final IExpenseRepository _expenseRepository;
  final IStatementRepository _statementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardBillSave({
    required ICreditCardBillRepository repository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
    required ICreditCardRepository creditCardRepository,
    required IExpenseRepository expenseRepository,
    required IStatementRepository statementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _creditCardTransactionRepository = creditCardTransactionRepository,
        _creditCardRepository = creditCardRepository,
        _expenseRepository = expenseRepository,
        _statementRepository = statementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<CreditCardBillEntity> payBill({required CreditCardBillEntity creditCardBill, required double payValue}) async {
    if (creditCardBill.totalSpent == 0) throw ValidationException(R.strings.noMovementsToPay);
    if (creditCardBill.status == BillStatusEnum.paid) throw ValidationException(R.strings.billAlreadyPaid);
    if (creditCardBill.billAmount <= 0) throw ValidationException(R.strings.billGreaterThanZero);
    if (payValue > creditCardBill.billAmount) throw ValidationException(R.strings.paymentExceedBillAmount);

    final CreditCardEntity creditCard = await _creditCardRepository.findById(creditCardBill.idCreditCard) ?? (throw ValidationException(R.strings.creditCardNotFound));

    final CreditCardBillEntity creditCardBillClone = creditCardBill.clone();

    final CreditCardTransactionEntity creditCardTransaction = CreditCardTransactionEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      description: R.strings.billPayment,
      amount: -payValue.abs(),
      date: DateTime.now(),
      idCategory: categoryBillUuidExpense,
      idCreditCard: creditCardBillClone.idCreditCard,
      idCreditCardBill: creditCardBillClone.id,
      observation: null,
    );

    final ExpenseEntity expense = ExpenseEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      description: creditCardTransaction.description,
      amount: creditCardTransaction.amount.abs(),
      date: DateTime.now(),
      paid: true,
      observation: creditCardTransaction.observation,
      idAccount: creditCard.idAccount,
      idCategory: creditCardTransaction.idCategory,
      idCreditCardTransaction: creditCardTransaction.id,
      idCreditCard: creditCardTransaction.idCreditCard,
    );

    if (creditCardBillClone.status == BillStatusEnum.paid) throw ValidationException(R.strings.billAlreadyPaid);

    await _localDBTransactionRepository.openTransaction((txn) async {
      await Future.wait([
        _creditCardTransactionRepository.save(creditCardTransaction, txn: txn).then((value) => creditCardBillClone.transactions.add(value)),
        _expenseRepository.save(expense, txn: txn),
        _statementRepository.save(StatementFactory.fromExpense(expense), txn: txn),
      ]);
    });

    return creditCardBillClone;
  }
}
