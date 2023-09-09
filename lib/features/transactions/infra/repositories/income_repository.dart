import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/income_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
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

    late final IncomeModel incomeResult;
    late final TransactionModel transactionResult;

    await _dbTransaction.openTransaction((txn) async {
      await Future.wait([
        Future(() async => transactionResult = await _transactionLocalDataSource.upsert(model.transaction, txn: txn)),
        Future(() async => incomeResult = await _incomeLocalDataSource.upsert(model, txn: txn)),
      ]);
    });

    incomeResult.transaction = transactionResult;

    return IncomeFactory.toEntity(incomeResult);
  }
}
