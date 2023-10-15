import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';

sealed class CreditCardExpenseState {
  final CreditCardTransactionEntity creditCardExpense;

  const CreditCardExpenseState({required this.creditCardExpense});

  factory CreditCardExpenseState.start() => StartCreditCardExpenseState();

  CreditCardExpenseState setCreditCardExpense(CreditCardTransactionEntity entity) => ChangedCreditCardExpenseState(creditCardExpense: entity);

  CreditCardExpenseState changedCreditCardExpense() => ChangedCreditCardExpenseState(creditCardExpense: creditCardExpense);

  CreditCardExpenseState setSaving() => SavingCreditCardExpenseState(creditCardExpense: creditCardExpense);

  CreditCardExpenseState setDeleting() => DeletingCreditCardExpenseState(creditCardExpense: creditCardExpense);

  CreditCardExpenseState setError(String message) => ErrorCreditCardExpenseState(message, creditCardExpense: creditCardExpense);
}

class StartCreditCardExpenseState extends CreditCardExpenseState {
  StartCreditCardExpenseState()
      : super(
          creditCardExpense: CreditCardTransactionEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: '',
            amount: 0,
            date: DateTime.now(),
            idCategory: null,
            idCreditCard: null,
            idCreditCardStatement: null,
            observation: null,
          ),
        );
}

class ChangedCreditCardExpenseState extends CreditCardExpenseState {
  const ChangedCreditCardExpenseState({required super.creditCardExpense});
}

class SavingCreditCardExpenseState extends CreditCardExpenseState {
  const SavingCreditCardExpenseState({required super.creditCardExpense});
}

class DeletingCreditCardExpenseState extends CreditCardExpenseState {
  const DeletingCreditCardExpenseState({required super.creditCardExpense});
}

class ErrorCreditCardExpenseState extends CreditCardExpenseState {
  final String message;

  const ErrorCreditCardExpenseState(this.message, {required super.creditCardExpense});
}
