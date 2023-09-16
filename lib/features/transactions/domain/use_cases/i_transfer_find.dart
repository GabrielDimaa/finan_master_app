import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';

abstract interface class ITransferFind {
  Future<List<TransferEntity>> findByPeriod(DateTime start, DateTime end);
}
