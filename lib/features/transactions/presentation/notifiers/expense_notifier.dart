import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/presentation/states/expense_state.dart';
import 'package:flutter/foundation.dart';

class ExpenseNotifier extends ValueNotifier<ExpenseState> {
  final IExpenseSave _expenseSave;

  ExpenseNotifier({required IExpenseSave expenseSave})
      : _expenseSave = expenseSave,
        super(ExpenseState.start());

  ExpenseEntity get expense => value.expense;

  bool get isLoading => value is SavingExpenseState || value is DeletingExpenseState;

  void updateExpense(ExpenseEntity expense) => value = value.updateExpense(expense);

  Future<ExpenseEntity> save() async {
    value = value.setSaving();
    return await _expenseSave.save(expense);
  }
}
