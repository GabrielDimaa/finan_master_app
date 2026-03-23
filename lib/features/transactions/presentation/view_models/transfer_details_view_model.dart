import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class TransferDetailsViewModel extends ChangeNotifier {
  final ITransferFind _transferFind;
  final IAccountFind _accountFind;

  late final Command1<void, String> load;
  late final Command1<void, TransferEntity> delete;

  TransferDetailsViewModel({
    required ITransferFind transferFind,
    required ITransferDelete transferDelete,
    required IAccountFind accountFind,
  })  : _transferFind = transferFind,
        _accountFind = accountFind {
    load = Command1(_load);
    delete = Command1(transferDelete.delete);
  }

  late TransferEntity _transfer;

  TransferEntity get transfer => _transfer;

  late AccountEntity _accountFrom;

  AccountEntity get accountFrom => _accountFrom;

  late AccountEntity _accountTo;

  AccountEntity get accountTo => _accountTo;

  Future<void> _load(String idTransfer) async {
    _transfer = await _transferFind.findById(idTransfer) ?? (throw Exception(R.strings.transactionNotFound));

    await Future.wait([
      _accountFind.findById(_transfer.idAccountFrom!, deleted: true).then((value) => _accountFrom = value ?? (throw Exception(R.strings.accountNotFound))),
      _accountFind.findById(_transfer.idAccountTo!, deleted: true).then((value) => _accountTo = value ?? (throw Exception(R.strings.accountNotFound))),
    ]);
  }
}
