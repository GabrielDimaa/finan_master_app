import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/income_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class IncomeRepository implements IIncomeRepository {
  final IDatabaseLocalTransaction _dbTransaction;
  final IIncomeLocalDataSource _incomeLocalDataSource;
  final ITransactionLocalDataSource _transactionLocalDataSource;

  IncomeRepository({
    required IDatabaseLocalTransaction dbTransaction,
    required IIncomeLocalDataSource incomeLocalDataSource,
    required ITransactionLocalDataSource transactionLocalDataSource,
  })  : _dbTransaction = dbTransaction,
        _incomeLocalDataSource = incomeLocalDataSource,
        _transactionLocalDataSource = transactionLocalDataSource;

  @override
  Future<IncomeEntity> save(IncomeEntity entity) async {
    final IncomeModel model = IncomeFactory.fromEntity(entity);

    final IncomeModel result = await _dbTransaction.openTransaction<IncomeModel>((txn) async {
      model.transaction = await _transactionLocalDataSource.upsert(model.transaction, txn: txn);
      return await _incomeLocalDataSource.upsert(model, txn: txn);
    });

    return IncomeFactory.toEntity(result);
  }

  @override
  Future<List<IncomeEntity>> findByPeriod(DateTime start, DateTime end) async {
    final List<IncomeModel> result = await _incomeLocalDataSource.findByPeriod(start, end);
    return result.map((e) => IncomeFactory.toEntity(e)).toList();
  }
}
