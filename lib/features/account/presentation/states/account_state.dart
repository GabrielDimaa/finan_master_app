import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';

sealed class AccountState {
  final AccountEntity account;

  const AccountState({required this.account});

  factory AccountState.start() => StartAccountState();

  AccountState setAccount(AccountEntity account) => ChangedAccountState(account: account);

  AccountState changedAccount() => ChangedAccountState(account: account);

  AccountState setSaving() => SavingAccountState(account: account);

  AccountState setDeleting() => DeletingAccountState(account: account);

  AccountState setFinding() => FindingAccountState(account: account);

  AccountState setError(String message) => ErrorAccountState(message, account: account);
}

class StartAccountState extends AccountState {
  StartAccountState()
      : super(
          account: AccountEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: '',
            transactionsAmount: 0,
            initialAmount: 0,
            financialInstitution: null,
            includeTotalBalance: true,
          ),
        );
}

class ChangedAccountState extends AccountState {
  const ChangedAccountState({required super.account});
}

class SavingAccountState extends AccountState {
  const SavingAccountState({required super.account});
}

class DeletingAccountState extends AccountState {
  const DeletingAccountState({required super.account});
}

class FindingAccountState extends AccountState {
  const FindingAccountState({required super.account});
}

class ErrorAccountState extends AccountState {
  final String message;

  ErrorAccountState(this.message, {required super.account});
}
