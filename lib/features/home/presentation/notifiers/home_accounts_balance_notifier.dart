import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/home/presentation/states/home_accounts_balance_state.dart';
import 'package:flutter/foundation.dart';

class HomeAccountsBalanceNotifier extends ValueNotifier<HomeAccountsBalanceState> {
  final IAccountFind _accountFind;

  HomeAccountsBalanceNotifier({required IAccountFind accountFind})
      : _accountFind = accountFind,
        super(HomeAccountsBalanceState.start());

  double get balance => value.balance;

  Future<void> load() async {
    try {
      value = value.setLoading();

      final double balance = await _accountFind.findAccountsBalance();

      value = value.setBalance(balance);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
