import 'package:finan_master_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class ITransactionRepository {
  Future<TransactionEntity> save(TransactionEntity entity, {ITransactionExecutor? txn});

  Future<TransactionEntity?> findById(String id);
}
