import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class AccountFormViewModel extends ChangeNotifier {
  late final Command1<void, AccountEntity> save;
  late final Command1<void, AccountEntity> delete;

  AccountFormViewModel({required IAccountSave accountSave, required IAccountDelete accountDelete}) {
    save = Command1<void, AccountEntity>(accountSave.save);
    delete = Command1<void, AccountEntity>(accountDelete.delete);
  }

  AccountEntity _account = AccountFactory.newEntity();

  AccountEntity get account => _account;

  void load(AccountEntity value) {
    _account = value;
    notifyListeners();
  }

  void setFinancialInstitution(FinancialInstitutionEnum? financialInstitution) async {
    _account.financialInstitution = financialInstitution;
    notifyListeners();
  }

  void setIncludeTotalBalance(bool? include) {
    _account.includeTotalBalance = include ?? false;
    notifyListeners();
  }
}
