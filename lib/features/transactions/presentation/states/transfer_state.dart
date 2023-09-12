import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';

sealed class TransferState {
  final TransferEntity transfer;

  const TransferState({required this.transfer});

  factory TransferState.start() => StartTransferState();

  TransferState updateTransfer(TransferEntity transfer) => ChangedTransferState(transfer: transfer);

  TransferState setSaving() => SavingTransferState(transfer: transfer);

  TransferState changedTransfer() => ChangedTransferState(transfer: transfer);

  TransferState setDeleting() => DeletingTransferState(transfer: transfer);
}

class StartTransferState extends TransferState {
  StartTransferState()
      : super(
          transfer: TransferEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            transactionFrom: null,
            transactionTo: null,
          ),
        );
}

class ChangedTransferState extends TransferState {
  const ChangedTransferState({required super.transfer});
}

class SavingTransferState extends TransferState {
  const SavingTransferState({required super.transfer});
}

class DeletingTransferState extends TransferState {
  const DeletingTransferState({required super.transfer});
}
