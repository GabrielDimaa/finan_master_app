import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transfer_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class TransferRepository implements ITransferRepository {
  final IDatabaseLocalTransaction _dbTransaction;
  final ITransferLocalDataSource _transferLocalDataSource;
  final ITransactionLocalDataSource _transactionLocalDataSource;
  final EventNotifier _eventNotifier;

  TransferRepository({
    required IDatabaseLocalTransaction dbTransaction,
    required ITransferLocalDataSource transferLocalDataSource,
    required ITransactionLocalDataSource transactionLocalDataSource,
    required EventNotifier eventNotifier,
  })  : _dbTransaction = dbTransaction,
        _transferLocalDataSource = transferLocalDataSource,
        _transactionLocalDataSource = transactionLocalDataSource,
        _eventNotifier = eventNotifier;

  @override
  Future<TransferEntity> save(TransferEntity entity) async {
    final TransferModel model = TransferFactory.fromEntity(entity);

    final TransferModel result = await _dbTransaction.openTransaction<TransferModel>((txn) async {
      model.transactionFrom = await _transactionLocalDataSource.upsert(model.transactionFrom, txn: txn);
      model.transactionTo = await _transactionLocalDataSource.upsert(model.transactionTo, txn: txn);
      return await _transferLocalDataSource.upsert(model, txn: txn);
    });

    _eventNotifier.notify(EventType.transactions);

    return TransferFactory.toEntity(result);
  }

  @override
  Future<void> delete(TransferEntity entity, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((txn) => delete(entity, txn: txn));
      return;
    }

    final TransferModel model = TransferFactory.fromEntity(entity);

    await _transferLocalDataSource.delete(model, txn: txn);
    await _transactionLocalDataSource.delete(model.transactionFrom, txn: txn);
    await _transactionLocalDataSource.delete(model.transactionTo, txn: txn);

    _eventNotifier.notify(EventType.transactions);
  }
}
