import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class ITransferDelete {
  Future<void> delete(TransferEntity entity, {ITransactionExecutor? txn});
}
