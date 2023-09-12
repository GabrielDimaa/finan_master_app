import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transfer_state.dart';
import 'package:flutter/foundation.dart';

class TransferNotifier extends ValueNotifier<TransferState> {
  final ITransferSave _transferSave;

  TransferNotifier({required ITransferSave transferSave})
      : _transferSave = transferSave,
        super(TransferState.start());

  TransferEntity get transfer => value.transfer;

  bool get isLoading => value is SavingTransferState || value is DeletingTransferState;

  void updateTransfer(TransferEntity transfer) => value = value.updateTransfer(transfer);

  void setAccountFrom(String idAccount) {
    transfer.transactionFrom.idAccount = idAccount;
    value = value.changedTransfer();
  }

  void setAccountTo(String idAccount) {
    transfer.transactionTo.idAccount = idAccount;
    value = value.changedTransfer();
  }

  void setDate(DateTime date) {
    transfer.date = date;
    value = value.changedTransfer();
  }

  Future<TransferEntity> save() async {
    value = value.setSaving();
    return await _transferSave.save(transfer);
  }
}
