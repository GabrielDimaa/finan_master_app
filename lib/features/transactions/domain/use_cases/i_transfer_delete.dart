import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';

abstract interface class ITransferDelete {
  Future<void> delete(TransferEntity entity);
}
