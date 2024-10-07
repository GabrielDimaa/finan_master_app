import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transfer_state.dart';
import 'package:flutter/foundation.dart';

class TransferNotifier extends ValueNotifier<TransferState> {
  final ITransferSave _transferSave;
  final ITransferDelete _transferDelete;

  TransferNotifier({required ITransferSave transferSave, required ITransferDelete transferDelete})
      : _transferSave = transferSave,
        _transferDelete = transferDelete,
        super(TransferState.start());

  TransferEntity get transfer => value.transfer;

  bool get isLoading => value is SavingTransferState || value is DeletingTransferState;

  void setTransfer(TransferEntity transfer) => value = value.setTransfer(transfer);

  void setAccountFrom(String idAccount) {
    transfer.idAccountFrom = idAccount;
    value = value.changedTransfer();
  }

  void setAccountTo(String idAccount) {
    transfer.idAccountTo = idAccount;
    value = value.changedTransfer();
  }

  void setDate(DateTime date) {
    transfer.date = date;
    value = value.changedTransfer();
  }

  Future<void> save() async {
    try {
      value = value.setSaving();
      await _transferSave.save(transfer);
      value = value.changedTransfer();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      value = value.setDeleting();
      await _transferDelete.delete(transfer);
      value = value.changedTransfer();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
