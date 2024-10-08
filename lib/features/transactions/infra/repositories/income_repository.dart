import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/income_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class IncomeRepository implements IIncomeRepository {
  final IDatabaseLocalTransaction _dbTransaction;
  final IIncomeLocalDataSource _incomeLocalDataSource;
  final ITransactionLocalDataSource _transactionLocalDataSource;
  final EventNotifier _eventNotifier;

  IncomeRepository({
    required IDatabaseLocalTransaction dbTransaction,
    required IIncomeLocalDataSource incomeLocalDataSource,
    required ITransactionLocalDataSource transactionLocalDataSource,
    required EventNotifier eventNotifier,
  })  : _dbTransaction = dbTransaction,
        _incomeLocalDataSource = incomeLocalDataSource,
        _transactionLocalDataSource = transactionLocalDataSource,
        _eventNotifier = eventNotifier;

  @override
  Future<IncomeEntity> save(IncomeEntity entity) async {
    final IncomeModel model = IncomeFactory.fromEntity(entity);

    final IncomeModel result = await _dbTransaction.openTransaction<IncomeModel>((txn) async {
      model.transaction = await _transactionLocalDataSource.upsert(model.transaction, txn: txn);
      return await _incomeLocalDataSource.upsert(model, txn: txn);
    });

    _eventNotifier.notify(EventType.income);

    return IncomeFactory.toEntity(result);
  }

  @override
  Future<void> delete(IncomeEntity entity, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction<void>((txn) => delete(entity, txn: txn));
      return;
    }

    final IncomeModel model = IncomeFactory.fromEntity(entity);

    await _incomeLocalDataSource.delete(model, txn: txn);
    await _transactionLocalDataSource.delete(model.transaction, txn: txn);

    _eventNotifier.notify(EventType.income);
  }
}
