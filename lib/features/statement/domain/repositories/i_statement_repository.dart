import 'package:finan_master_app/features/statement/domain/entities/statement_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class IStatementRepository {
  Future<StatementEntity> save(StatementEntity entity, {ITransactionExecutor? txn});

  Future<StatementEntity?> findByIdExpense(String id);

  Future<StatementEntity?> findByIdIncome(String id);

  Future<List<StatementEntity>> findByIdTransfer(String id);

  Future<void> deleteByIdExpense(String id, {ITransactionExecutor? txn});

  Future<void> deleteByIdsExpense(List<String> ids, {ITransactionExecutor? txn});

  Future<void> deleteByIdIncome(String id, {ITransactionExecutor? txn});

  Future<void> deleteByIdTransfer(String id, {ITransactionExecutor? txn});
}
