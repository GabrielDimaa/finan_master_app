import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

abstract interface class ITransferRepository {
  Future<Result<TransferEntity, BaseException>> save(TransferEntity entity);
}
