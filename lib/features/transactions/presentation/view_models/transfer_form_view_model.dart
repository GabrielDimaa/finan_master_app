import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transfer_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class TransferFormViewModel extends ChangeNotifier {
  final IAccountFind _accountFind;

  late final Command1<void, TransferEntity?> init;
  late final Command1<void, TransferEntity> save;
  late final Command1<void, TransferEntity> delete;

  TransferFormViewModel({
    required ITransferSave transferSave,
    required ITransferDelete transferDelete,
    required IAccountFind accountFind,
  }) : _accountFind = accountFind {
    init = Command1(_init);
    save = Command1(transferSave.save);
    delete = Command1(transferDelete.delete);
  }

  bool get isLoading => save.running || delete.running;

  TransferEntity _transfer = TransferFactory.newEntity();

  TransferEntity get transfer => _transfer;

  List<AccountEntity> _accounts = [];

  List<AccountEntity> get accounts => _accounts;

  Future<void> _init(TransferEntity? transfer) async {
    await Future.wait([
      _accountFind.findAll(deleted: true).then((value) => _accounts = value),
    ]);

    if (transfer != null) _transfer = transfer;
  }

  void setAccountFrom(String idAccount) {
    _transfer.idAccountFrom = idAccount;
    notifyListeners();
  }

  void setAccountTo(String idAccount) {
    _transfer.idAccountTo = idAccount;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _transfer.date = date;
    notifyListeners();
  }
}
