import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class AccountDetailsViewModel extends ChangeNotifier {
  late final Command1<void, AccountEntity> delete;

  AccountDetailsViewModel({required IAccountDelete accountDelete}) {
    delete = Command1<void, AccountEntity>(accountDelete.delete);
  }

  AccountEntity _account = AccountFactory.newEntity();

  AccountEntity get account => _account;

  void setAccount(AccountEntity value) {
    _account = value;
    notifyListeners();
  }
}
