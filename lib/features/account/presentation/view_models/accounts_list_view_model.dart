import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class AccountsListViewModel extends ChangeNotifier {
  late final Command0<List<AccountEntity>> findAll;

  AccountsListViewModel({required IAccountFind accountFind}) {
    findAll = Command0<List<AccountEntity>>(accountFind.findAll);
  }
}
