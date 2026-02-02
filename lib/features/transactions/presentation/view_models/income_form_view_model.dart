import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/income_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class IncomeFormViewModel extends ChangeNotifier {
  final ICategoryFind _categoryFind;
  final IAccountFind _accountFind;

  late final Command1<void, IncomeEntity?> init;
  late final Command1<IncomeEntity, IncomeEntity> save;
  late final Command1<void, IncomeEntity> delete;
  late final Command1<List<TransactionByTextEntity>, String> findByText;

  IncomeFormViewModel({
    required IIncomeSave incomeSave,
    required IIncomeDelete incomeDelete,
    required IIncomeFind incomeFind,
    required ICategoryFind categoryFind,
    required IAccountFind accountFind,
  })  : _categoryFind = categoryFind,
        _accountFind = accountFind {
    init = Command1(_init);
    save = Command1(incomeSave.save);
    delete = Command1(incomeDelete.delete);
    findByText = Command1(incomeFind.findByText);
  }

  bool get isLoading => save.running || delete.running;

  IncomeEntity _income = IncomeFactory.newEntity();

  IncomeEntity get income => _income;

  List<CategoryEntity> _categories = [];

  List<AccountEntity> _accounts = [];

  List<CategoryEntity> get categories => _categories;

  List<AccountEntity> get accounts => _accounts;

  Future<void> _init(IncomeEntity? income) async {
    await Future.wait([
      _categoryFind.findAll(type: CategoryTypeEnum.income, deleted: true).then((value) => _categories = value),
      _accountFind.findAll(deleted: true).then((value) => _accounts = value),
    ]);

    if (income != null) {
      _income = income;
    } else {
      final AccountEntity? account = _accounts.where((account) => account.deletedAt == null).singleOrNull;
      if (account != null) _income.idAccount = account.id;
    }
  }

  void setIdCategory(String value) {
    income.idCategory = value;
    notifyListeners();
  }

  void setIdAccount(String value) {
    income.idAccount = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    income.date = value;
    notifyListeners();
  }

  void setReceived(bool value) {
    income.received = value;
    notifyListeners();
  }
}
