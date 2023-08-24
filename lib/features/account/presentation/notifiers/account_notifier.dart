import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/adjustment_option_enum.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/account/presentation/states/account_state.dart';
import 'package:flutter/foundation.dart';

class AccountNotifier extends ValueNotifier<AccountState> {
  final IAccountSave _accountSave;
  final IAccountDelete _accountDelete;

  AccountNotifier({required IAccountSave accountSave, required IAccountDelete accountDelete})
      : _accountSave = accountSave,
        _accountDelete = accountDelete,
        super(AccountState.start());

  AccountEntity get account => value.account;

  bool get isLoading => value is SavingAccountState || value is DeletingAccountState;

  void setAccount(AccountEntity account) => value = value.setAccount(account);

  void setFinancialInstitution(FinancialInstitutionEnum? financialInstitution) async {
    value.account.financialInstitution = financialInstitution;
    value = value.changedAccount();
  }

  void setIncludeTotalBalance(bool? include) {
    value.account.includeTotalBalance = include ?? false;
    value = value.changedAccount();
  }

  Future<void> save() async {
    value = value.setSaving();

    final result = await _accountSave.save(account);

    result.fold(
      (success) => null,
      (failure) => throw failure,
    );
  }

  Future<void> delete() async {
    value = value.setDeleting();

    final result = await _accountDelete.delete(account);

    result.fold(
      (success) => null,
      (failure) => throw failure,
    );
  }

  Future<void> readjustBalance({required double readjustmentValue, required ReadjustmentOptionEnum option, required String? description}) async {
    value = value.setSaving();

    if (option == ReadjustmentOptionEnum.changeInitialValue) {
      final result = await _accountSave.readjustBalance(account, readjustmentValue);

      result.fold(
        (success) => value.setAccount(success),
        (failure) => throw failure,
      );
    } else {
      //TODO: Criar transação de reajuste.
    }
  }
}
