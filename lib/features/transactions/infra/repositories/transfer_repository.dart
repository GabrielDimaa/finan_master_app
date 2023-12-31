import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transfer_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class TransferRepository implements ITransferRepository {
  final IDatabaseLocalTransaction _dbTransaction;
  final ITransferLocalDataSource _transferLocalDataSource;
  final ITransactionLocalDataSource _transactionLocalDataSource;

  TransferRepository({
    required IDatabaseLocalTransaction dbTransaction,
    required ITransferLocalDataSource transferLocalDataSource,
    required ITransactionLocalDataSource transactionLocalDataSource,
  })  : _dbTransaction = dbTransaction,
        _transferLocalDataSource = transferLocalDataSource,
        _transactionLocalDataSource = transactionLocalDataSource;

  @override
  Future<TransferEntity> save(TransferEntity entity) async {
    final TransferModel model = TransferFactory.fromEntity(entity);

    final TransferModel result = await _dbTransaction.openTransaction<TransferModel>((txn) async {
      model.transactionFrom = await _transactionLocalDataSource.upsert(model.transactionFrom, txn: txn);
      model.transactionTo = await _transactionLocalDataSource.upsert(model.transactionTo, txn: txn);
      return await _transferLocalDataSource.upsert(model, txn: txn);
    });

    return TransferFactory.toEntity(result);
  }

  @override
  Future<void> delete(TransferEntity entity, {ITransactionExecutor? txn}) async {
    final TransferModel model = TransferFactory.fromEntity(entity);

    if (txn != null) {
      await _transferLocalDataSource.delete(model, txn: txn);
      await _transactionLocalDataSource.delete(model.transactionFrom, txn: txn);
      await _transactionLocalDataSource.delete(model.transactionTo, txn: txn);
    } else {
      await _dbTransaction.openTransaction((txn) async {
        await _transferLocalDataSource.delete(model, txn: txn);
        await _transactionLocalDataSource.delete(model.transactionFrom, txn: txn);
        await _transactionLocalDataSource.delete(model.transactionTo, txn: txn);
      });
    }
  }
}
