import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/income_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_by_text_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';

class IncomeRepository implements IIncomeRepository {
  final IIncomeLocalDataSource _incomeLocalDataSource;
  final EventNotifier _eventNotifier;

  IncomeRepository({
    required IIncomeLocalDataSource incomeLocalDataSource,
    required EventNotifier eventNotifier,
  })  : _incomeLocalDataSource = incomeLocalDataSource,
        _eventNotifier = eventNotifier;

  @override
  Future<IncomeEntity> save(IncomeEntity entity, {ITransactionExecutor? txn}) async {
    final IncomeModel result = await _incomeLocalDataSource.upsert(IncomeFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.income);

    return IncomeFactory.toEntity(result);
  }

  @override
  Future<void> delete(IncomeEntity entity, {ITransactionExecutor? txn}) async {
    await _incomeLocalDataSource.delete(IncomeFactory.fromEntity(entity), txn: txn);

    _eventNotifier.notify(EventType.income);
  }

  @override
  Future<List<IncomeEntity>> findByPeriod(DateTime startDate, DateTime endDate) async {
    final List<IncomeModel> models = await _incomeLocalDataSource.findAll(where: 'date >= ? AND date <= ?', whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()]);

    return models.map((model) => IncomeFactory.toEntity(model)).toList();
  }

  @override
  Future<List<TransactionByTextEntity>> findByText(String text) async {
    final List<TransactionByTextModel> models = await _incomeLocalDataSource.findByText(text);

    return models
        .map((model) => TransactionByTextEntity(
              description: model.description,
              idCategory: model.idCategory,
              idAccount: model.idAccount,
              idCreditCard: model.idCreditCard,
              observation: model.observation,
            ))
        .toList();
  }
}
