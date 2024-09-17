import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_save.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardBillSave implements ICreditCardBillSave {
  final ICreditCardBillRepository _repository;
  final ICreditCardTransactionRepository _creditCardTransactionRepository;
  final ICreditCardRepository _creditCardRepository;
  final IExpenseRepository _expenseRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardBillSave({
    required ICreditCardBillRepository repository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
    required ICreditCardRepository creditCardRepository,
    required IExpenseRepository expenseRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _creditCardTransactionRepository = creditCardTransactionRepository,
        _creditCardRepository = creditCardRepository,
        _expenseRepository = expenseRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<CreditCardBillEntity> payBill({required CreditCardBillEntity creditCardBill, required double payValue}) async {
    if (creditCardBill.totalSpent == 0) throw ValidationException(R.strings.noMovementsToPay);
    if (creditCardBill.status == BillStatusEnum.paid) throw ValidationException(R.strings.billAlreadyPaid);
    if (creditCardBill.billAmount <= 0) throw ValidationException(R.strings.billGreaterThanZero);
    if (payValue > creditCardBill.billAmount) throw ValidationException(R.strings.paymentExceedBillAmount);

    final CreditCardEntity creditCard = await _creditCardRepository.findById(creditCardBill.idCreditCard) ?? (throw ValidationException(R.strings.creditCardNotFound));

    final CreditCardBillEntity creditCardBillClone = creditCardBill.clone();

    CreditCardTransactionEntity creditCardTransaction = CreditCardTransactionEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      description: R.strings.billPayment,
      amount: payValue * (-1),
      date: DateTime.now(),
      idCategory: categoryOthersUuidExpense,
      idCreditCard: creditCardBillClone.idCreditCard,
      idCreditCardBill: creditCardBillClone.id,
      observation: null,
    );

    //Se a fatura estiver em aberto
    if (creditCardBillClone.status == BillStatusEnum.outstanding) {
      final ExpenseEntity expense = CreditCardTransactionFactory.toExpenseEntity(creditCardTransaction)
        ..amount = creditCardTransaction.amount.abs()
        ..idAccount = creditCard.idAccount;

      await _localDBTransactionRepository.openTransaction((txn) async {
        creditCardTransaction = await _creditCardTransactionRepository.save(creditCardTransaction, txn: txn);
        await _expenseRepository.save(expense, txn: txn);
      });

      creditCardBillClone.transactions.add(creditCardTransaction);
      return creditCardBillClone;
    }

    //Se a fatura estiver fechada ou vencida
    if (creditCardBillClone.status == BillStatusEnum.closed || creditCardBillClone.status == BillStatusEnum.overdue) {
      if (payValue != creditCardBill.billAmount.truncateFractionalDigits(2)) throw ValidationException(R.strings.paymentRequirementWhenClosedBill);

      final List<ExpenseEntity> expenses = [];

      for (CreditCardTransactionEntity transaction in creditCardBillClone.transactions) {
        expenses.add(CreditCardTransactionFactory.toExpenseEntity(transaction)
          ..amount = transaction.amount
          ..idAccount = creditCard.idAccount);
      }

      //Atualiza a fatura com status de "Paga"
      creditCardBillClone.paid = true;

      await _localDBTransactionRepository.openTransaction((txn) async {
        final expenseSaves = expenses.map((expense) => () => _expenseRepository.save(expense, txn: txn));

        creditCardTransaction = await _creditCardTransactionRepository.save(creditCardTransaction, txn: txn);

        await Future.wait([
          _repository.saveOnlyBill(creditCardBillClone, txn: txn),
          ...expenseSaves.map((e) => e.call()),
        ]);
      });

      creditCardBillClone.transactions.add(creditCardTransaction);
      return creditCardBillClone;
    }

    throw ValidationException(R.strings.notPossibleToPayBill);
  }
}
