import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';

sealed class ExpenseState {
  final ExpenseEntity expense;

  const ExpenseState({required this.expense});

  factory ExpenseState.start() => StartExpenseState();

  ExpenseState setExpense(ExpenseEntity expense) => ChangedExpenseState(expense: expense);

  ExpenseState changedExpense() => ChangedExpenseState(expense: expense);

  ExpenseState setSaving() => SavingExpenseState(expense: expense);

  ExpenseState setDeleting() => DeletingExpenseState(expense: expense);

  ExpenseState setError(String message) => ErrorExpenseState(message, expense: expense);
}

class StartExpenseState extends ExpenseState {
  StartExpenseState()
      : super(
          expense: ExpenseEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: '',
            amount: 0,
            date: DateTime.now(),
            paid: true,
            observation: null,
            idAccount: null,
            idCategory: null,
            idCreditCard: null,
            idCreditCardTransaction: null,
          ),
        );
}

class ChangedExpenseState extends ExpenseState {
  const ChangedExpenseState({required super.expense});
}

class SavingExpenseState extends ExpenseState {
  const SavingExpenseState({required super.expense});
}

class DeletingExpenseState extends ExpenseState {
  const DeletingExpenseState({required super.expense});
}

class ErrorExpenseState extends ExpenseState {
  final String message;

  const ErrorExpenseState(this.message, {required super.expense});
}
