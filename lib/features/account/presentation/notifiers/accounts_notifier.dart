import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:flutter/foundation.dart';

class AccountsNotifier extends ValueNotifier<AccountsState> {
  final IAccountFind _accountFind;

  AccountsNotifier({required IAccountFind accountFind})
      : _accountFind = accountFind,
        super(AccountsState.start());

  Future<void> findAll() async {
    try {
      value = value.setLoading();

      final result = await _accountFind.findAll();

      result.fold(
        (success) => value = value.setAccounts(success),
        (failure) => value = value.setError(failure.message),
      );
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
