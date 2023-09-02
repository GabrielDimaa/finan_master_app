import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transfer_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
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

    late final TransferModel transferResult;
    late final TransactionModel transactionFromResult;
    late final TransactionModel transactionToResult;

    await _dbTransaction.openTransaction((txn) async {
      Future.wait([
        Future.value(() async => transactionFromResult = await _transactionLocalDataSource.upsert(model.transactionFrom)),
        Future.value(() async => transactionToResult = await _transactionLocalDataSource.upsert(model.transactionTo)),
        Future.value(() async => transferResult = await _transferLocalDataSource.upsert(model)),
      ]);
    });

    transferResult.transactionFrom = transactionFromResult;
    transferResult.transactionTo = transactionToResult;

    return TransferFactory.toEntity(transferResult);
  }
}
