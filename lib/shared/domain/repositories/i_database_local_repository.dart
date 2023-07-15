import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/model/model.dart';

abstract interface class IDatabaseLocalRepository<T extends Model> {
  String get tableName;

  void createTable(IDatabaseLocalBatch batch);

  List<T> childrenModels(dynamic model);

  T fromMap(Map<String, dynamic> map, {String prefix = ''});

  Future<T> upsert(T model, {ITransactionExecutor? txn});

  Future<T> insert(T model, {ITransactionExecutor? txn});

  Future<T> update(T model, {ITransactionExecutor? txn});

  Future<void> delete(T model, {ITransactionExecutor? txn});

  Future<bool> exists({required String where, List<dynamic>? whereArgs, ITransactionExecutor? txn});

  Future<T?> findOne({ITransactionExecutor? txn});

  Future<T?> findById(String id, {bool deleted = false, ITransactionExecutor? txn});

  Future<List<T>> findAll({bool deleted = false, ITransactionExecutor? txn});
}
