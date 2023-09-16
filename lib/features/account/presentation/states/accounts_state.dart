import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';

sealed class AccountsState {
  final List<AccountEntity> accounts;

  const AccountsState(this.accounts);

  factory AccountsState.start() => const StartAccountsState([]);

  AccountsState setAccounts(List<AccountEntity> accounts) => accounts.isEmpty ? const EmptyAccountsState([]) : ListAccountsState(accounts);

  AccountsState setLoading() => const LoadingAccountsState([]);

  AccountsState setError(String message) => ErrorAccountsState(message);
}

class StartAccountsState extends AccountsState {
  const StartAccountsState(super.accounts);
}

class ListAccountsState extends AccountsState {
  const ListAccountsState(super.categories);
}

class EmptyAccountsState extends AccountsState {
  const EmptyAccountsState(super.categories);
}

class LoadingAccountsState extends AccountsState {
  const LoadingAccountsState(super.categories);
}

class ErrorAccountsState extends AccountsState {
  final String message;

  const ErrorAccountsState(this.message) : super(const []);
}
