import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class IncomeDetailsViewModel extends ChangeNotifier {
  final IIncomeFind _incomeFind;
  final IIncomeSave _incomeSave;
  final ICategoryFind _categoryFind;
  final IAccountFind _accountFind;

  late final Command1<void, String> load;
  late final Command1<void, bool> saveReceived;
  late final Command1<void, IncomeEntity> delete;

  IncomeDetailsViewModel({
    required IIncomeFind incomeFind,
    required IIncomeSave incomeSave,
    required IIncomeDelete incomeDelete,
    required ICategoryFind categoryFind,
    required IAccountFind accountFind,
  })  : _incomeFind = incomeFind,
        _incomeSave = incomeSave,
        _categoryFind = categoryFind,
        _accountFind = accountFind {
    load = Command1(_load);
    saveReceived = Command1(_saveReceived);
    delete = Command1(incomeDelete.delete);
  }

  late IncomeEntity _income;

  IncomeEntity get income => _income;

  late CategoryEntity _category;

  CategoryEntity get category => _category;

  late AccountEntity _account;

  AccountEntity get account => _account;

  Future<void> _load(String idIncome) async {
    _income = await _incomeFind.findById(idIncome) ?? (throw Exception(R.strings.transactionNotFound));

    await Future.wait([
      _categoryFind.findById(_income.idCategory!, deleted: true).then((value) => _category = value ?? (throw Exception(R.strings.categoryNotFound))),
      _accountFind.findById(_income.idAccount!, deleted: true).then((value) => _account = value ?? (throw Exception(R.strings.accountNotFound))),
    ]);
  }

  Future<void> _saveReceived(bool value) async {
    await _incomeSave.saveReceived(received: value, id: _income.id);
    _income.received = value;

    notifyListeners();
  }
}
