import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class ExpenseDetailsViewModel extends ChangeNotifier {
  final IExpenseFind _expenseFind;
  final IExpenseSave _expenseSave;
  final ICategoryFind _categoryFind;
  final IAccountFind _accountFind;

  late final Command1<void, String> load;
  late final Command1<void, bool> savePaid;
  late final Command1<void, ExpenseEntity> delete;

  ExpenseDetailsViewModel({
    required IExpenseFind expenseFind,
    required IExpenseSave expenseSave,
    required IExpenseDelete expenseDelete,
    required ICategoryFind categoryFind,
    required IAccountFind accountFind,
  })  : _expenseFind = expenseFind,
        _expenseSave = expenseSave,
        _categoryFind = categoryFind,
        _accountFind = accountFind {
    load = Command1(_load);
    savePaid = Command1(_savePaid);
    delete = Command1(expenseDelete.delete);
  }

  late ExpenseEntity _expense;

  ExpenseEntity get expense => _expense;

  late CategoryEntity _category;

  CategoryEntity get category => _category;

  late AccountEntity _account;

  AccountEntity get account => _account;

  Future<void> _load(String idExpense) async {
    _expense = await _expenseFind.findById(idExpense) ?? (throw Exception(R.strings.transactionNotFound));

    await Future.wait([
      _categoryFind.findById(_expense.idCategory!, deleted: true).then((value) => _category = value ?? (throw Exception(R.strings.categoryNotFound))),
      _accountFind.findById(_expense.idAccount!, deleted: true).then((value) => _account = value ?? (throw Exception(R.strings.accountNotFound))),
    ]);
  }

  Future<void> _savePaid(bool value) async {
    await _expenseSave.savePaid(paid: value, id: _expense.id);
    _expense.paid = value;

    notifyListeners();
  }
}
