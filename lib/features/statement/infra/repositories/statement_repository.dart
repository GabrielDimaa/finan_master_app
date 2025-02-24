import 'package:finan_master_app/features/statement/domain/entities/statement_entity.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/statement/helpers/statement_factory.dart';
import 'package:finan_master_app/features/statement/infra/data_sources/i_statement_local_data_source.dart';
import 'package:finan_master_app/features/statement/infra/models/statement_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class StatementRepository implements IStatementRepository {
  final IStatementLocalDataSource _dataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  StatementRepository({required IStatementLocalDataSource dataSource, required IDatabaseLocalTransaction dbTransaction,})
      : _dataSource = dataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<StatementEntity> save(StatementEntity entity, {ITransactionExecutor? txn}) async {
    final StatementModel result = await _dataSource.upsert(StatementFactory.fromEntity(entity), txn: txn);

    return StatementFactory.toEntity(result);
  }

  @override
  Future<StatementEntity?> findByIdExpense(String id) async {
    final StatementModel? model = await _dataSource.findOne(where: 'id_expense = ?', whereArgs: [id]);

    return model != null ? StatementFactory.toEntity(model) : null;
  }

  @override
  Future<StatementEntity?> findByIdIncome(String id) async {
    final StatementModel? model = await _dataSource.findOne(where: 'id_income = ?', whereArgs: [id]);

    return model != null ? StatementFactory.toEntity(model) : null;
  }

  @override
  Future<List<StatementEntity>> findByIdTransfer(String id) async {
    final List<StatementModel> models = await _dataSource.findAll(where: 'id_transfer = ?', whereArgs: [id]);

    return models.map((e) => StatementFactory.toEntity(e)).toList();
  }

  @override
  Future<void> deleteByIdExpense(String id, {ITransactionExecutor? txn}) => _dataSource.deleteByIdExpense(id, txn: txn);

  @override
  Future<void> deleteByIdsExpense(List<String> ids, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((newTxn) => deleteByIdsExpense(ids, txn: newTxn));
      return;
    }

    for (final id in ids) {
      await deleteByIdExpense(id, txn: txn);
    }
  }

  @override
  Future<void> deleteByIdIncome(String id, {ITransactionExecutor? txn}) => _dataSource.deleteByIdIncome(id, txn: txn);

  @override
  Future<void> deleteByIdTransfer(String id, {ITransactionExecutor? txn}) => _dataSource.deleteByIdTransfer(id, txn: txn);
}
