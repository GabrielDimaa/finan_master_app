import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';

abstract interface class ITransferRepository {
  Future<TransferEntity> save(TransferEntity entity);
}
