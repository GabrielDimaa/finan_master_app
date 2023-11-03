import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:flutter/foundation.dart';

class AccountsNotifier extends ValueNotifier<AccountsState> {
  final IAccountFind _accountFind;

  AccountsNotifier({required IAccountFind accountFind})
      : _accountFind = accountFind,
        super(AccountsState.start());

  double get accountsBalance => value.accounts.map((account) => account.deletedAt == null && account.includeTotalBalance ? account.balance : 0).sum.toDouble();

  Future<void> findAll({bool deleted = false}) async {
    try {
      value = value.setLoading();

      final List<AccountEntity> accounts = await _accountFind.findAll(deleted: deleted);
      value = value.setAccounts(accounts);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
