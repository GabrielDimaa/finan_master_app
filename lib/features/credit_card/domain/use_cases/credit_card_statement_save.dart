import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/statement_status_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_save.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardStatementSave implements ICreditCardStatementSave {
  final ICreditCardStatementRepository _repository;
  final ICreditCardTransactionRepository _creditCardTransactionRepository;
  final IExpenseRepository _expenseRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardStatementSave({
    required ICreditCardStatementRepository repository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
    required IExpenseRepository expenseRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _repository = repository,
        _creditCardTransactionRepository = creditCardTransactionRepository,
        _expenseRepository = expenseRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<CreditCardStatementEntity> payStatement({required CreditCardStatementEntity creditCardStatement, required double payValue}) async {
    if (creditCardStatement.status == StatementStatusEnum.noMovements) throw ValidationException(R.strings.noMovementsToPay);
    if (creditCardStatement.status == StatementStatusEnum.paid) throw ValidationException(R.strings.statementAlreadyPaid);
    if (creditCardStatement.statementAmount <= 0) throw ValidationException(R.strings.statementGreaterThanZero);
    if (payValue > creditCardStatement.statementAmount) throw ValidationException(R.strings.paymentExceedStatementAmount);

    final CreditCardStatementEntity creditCardStatementClone = creditCardStatement.clone();

    //Se a fatura estiver em aberto
    if (creditCardStatementClone.status == StatementStatusEnum.outstanding) {
      CreditCardTransactionEntity creditCardTransaction = CreditCardTransactionEntity(
        id: null,
        createdAt: null,
        deletedAt: null,
        description: R.strings.statementPayment,
        amount: payValue * (-1),
        date: DateTime.now(),
        idCategory: categoryOthersUuidExpense,
        idCreditCard: creditCardStatementClone.idCreditCard,
        idCreditCardStatement: creditCardStatementClone.id,
        observation: null,
      );

      creditCardTransaction = await _creditCardTransactionRepository.save(creditCardTransaction);
      creditCardStatementClone.transactions.insert(0, creditCardTransaction);
      return creditCardStatementClone;
    }

    //Se a fatura estiver fechada ou vencida
    if (creditCardStatementClone.status == StatementStatusEnum.closed || creditCardStatementClone.status == StatementStatusEnum.overdue) {
      if (payValue != creditCardStatement.statementAmount) throw ValidationException(R.strings.paymentExceedStatementAmount);

      final List<ExpenseEntity> expenses = [];

      for (CreditCardTransactionEntity transaction in creditCardStatementClone.transactions) {
        expenses.add(
          ExpenseEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: transaction.description,
            observation: transaction.observation,
            idCategory: transaction.idCategory,
            idCreditCardTransaction: transaction.id,
            transaction: null,
          ),
        );
      }

      //Atualiza a fatura com status de "Paga"
      creditCardStatementClone.paid = true;

      await _localDBTransactionRepository.openTransaction((txn) async {
        final expenseSaves = expenses.map((expense) => () => _expenseRepository.save(expense, txn: txn));

        await Future.wait([
          _repository.saveOnlyStatement(creditCardStatementClone, txn: txn),
          ...expenseSaves.map((e) => e.call()),
        ]);
      });

      return creditCardStatementClone;
    }

    throw ValidationException(R.strings.notPossibleToPayStatement);
  }
}
