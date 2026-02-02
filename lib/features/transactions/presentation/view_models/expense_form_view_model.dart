import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/expense_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class ExpenseFormViewModel extends ChangeNotifier {
  final ICategoryFind _categoryFind;
  final IAccountFind _accountFind;

  late final Command1<void, ExpenseEntity?> init;
  late final Command1<ExpenseEntity, ExpenseEntity> save;
  late final Command1<void, ExpenseEntity> delete;
  late final Command1<List<TransactionByTextEntity>, String> findByText;

  ExpenseFormViewModel({
    required IExpenseSave expenseSave,
    required IExpenseDelete expenseDelete,
    required IExpenseFind expenseFind,
    required ICategoryFind categoryFind,
    required IAccountFind accountFind,
  })  : _categoryFind = categoryFind,
        _accountFind = accountFind {
    init = Command1(_init);
    save = Command1(expenseSave.save);
    delete = Command1(expenseDelete.delete);
    findByText = Command1(expenseFind.findByText);
  }

  bool get isLoading => save.running || delete.running;

  ExpenseEntity _expense = ExpenseFactory.newEntity();

  ExpenseEntity get expense => _expense;

  List<CategoryEntity> _categories = [];

  List<AccountEntity> _accounts = [];

  List<CategoryEntity> get categories => _categories;

  List<AccountEntity> get accounts => _accounts;

  Future<void> _init(ExpenseEntity? expense) async {
    await Future.wait([
      _categoryFind.findAll(type: CategoryTypeEnum.expense, deleted: true).then((value) => _categories = value),
      _accountFind.findAll(deleted: true).then((value) => _accounts = value),
    ]);

    if (expense != null) {
      _expense = expense;
    } else {
      final AccountEntity? account = _accounts.where((account) => account.deletedAt == null).singleOrNull;
      if (account != null) _expense.idAccount = account.id;
    }
  }

  void setIdCategory(String value) {
    expense.idCategory = value;
    notifyListeners();
  }

  void setIdAccount(String value) {
    expense.idAccount = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    expense.date = value;
    notifyListeners();
  }

  void setPaid(bool value) {
    expense.paid = value;
    notifyListeners();
  }
}
