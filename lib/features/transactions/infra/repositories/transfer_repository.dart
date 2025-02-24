import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transfer_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class TransferRepository implements ITransferRepository {
  final ITransferLocalDataSource _transferLocalDataSource;
  final EventNotifier _eventNotifier;

  TransferRepository({
    required ITransferLocalDataSource transferLocalDataSource,
    required EventNotifier eventNotifier,
  })  : _transferLocalDataSource = transferLocalDataSource,
        _eventNotifier = eventNotifier;

  @override
  Future<TransferEntity> save(TransferEntity entity, {ITransactionExecutor? txn}) async {
    final TransferModel result = await _transferLocalDataSource.upsert(TransferFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.transfer);

    return TransferFactory.toEntity(result);
  }

  @override
  Future<void> delete(TransferEntity entity, {ITransactionExecutor? txn}) async {
    await _transferLocalDataSource.delete(TransferFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.transfer);
  }

  @override
  Future<List<TransferEntity>> findByPeriod(DateTime startDate, DateTime endDate) async {
    final List<TransferModel> models = await _transferLocalDataSource.findAll(where: 'date >= ? AND date <= ?', whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()]);

    return models.map((model) => TransferFactory.toEntity(model)).toList();
  }
}
