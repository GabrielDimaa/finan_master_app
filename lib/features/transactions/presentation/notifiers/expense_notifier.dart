import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/features/transactions/presentation/states/expense_state.dart';
import 'package:flutter/foundation.dart';

class ExpenseNotifier extends ValueNotifier<ExpenseState> {
  final IExpenseSave _expenseSave;
  final IExpenseDelete _expenseDelete;
  final ITransactionFind _transactionFind;

  ExpenseNotifier({
    required IExpenseSave expenseSave,
    required IExpenseDelete expenseDelete,
    required ITransactionFind transactionFind,
  })  : _expenseSave = expenseSave,
        _expenseDelete = expenseDelete,
        _transactionFind = transactionFind,
        super(ExpenseState.start());

  ExpenseEntity get expense => value.expense;

  bool get isLoading => value is SavingExpenseState || value is DeletingExpenseState;

  void setExpense(ExpenseEntity expense) => value = value.setExpense(expense);

  void setCategory(String idCategory) {
    expense.idCategory = idCategory;
    value = value.changedExpense();
  }

  void setAccount(String idAccount) {
    expense.transaction.idAccount = idAccount;
    value = value.changedExpense();
  }

  void setDate(DateTime date) {
    expense.transaction.date = date;
    value = value.changedExpense();
  }

  Future<void> save() async {
    try {
      value = value.setSaving();
      await _expenseSave.save(expense);
      value = value.changedExpense();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      value = value.setDeleting();
      await _expenseDelete.delete(expense);
      value = value.changedExpense();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<List<ExpenseEntity>> findByText(String text) async => (await _transactionFind.findByText(categoryType: CategoryTypeEnum.expense, text: text)).map((e) => e as ExpenseEntity).toList();
}
