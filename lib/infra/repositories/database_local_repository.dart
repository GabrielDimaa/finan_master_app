import 'package:finan_master_app/domain/repositories/i_database_local_repository.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/infra/model/model.dart';

abstract class DatabaseLocalRepository<T extends Model> implements IDatabaseLocalRepository<T> {
  final IDatabaseLocal databaseLocal;
  final List<IDatabaseLocalRepository> childrenRepositories;

  DatabaseLocalRepository({
    required this.databaseLocal,
    this.childrenRepositories = const [],
  });

  static const String separator = '~!@#%^&*()?';

  String baseColumnsSql() {
    return '''
      ${Model.idColumnName} TEXT NOT NULL PRIMARY KEY,
      ${Model.createdAtColumnName} TEXT NOT NULL,
      ${Model.deletedAtColumnName} TEXT
    ''';
  }

  String get orderByDefault => '${Model.createdAtColumnName} ASC';

  @override
  List<T> childrenModels(dynamic model) => [];

  @override
  Future<T> upsert(T model, {ITransactionExecutor? txn}) async {
    final T modelClone = model.clone() as T;

    fun(ITransactionExecutor transaction) async {
      if (!await exists(where: '${Model.idColumnName} = ?', whereArgs: [modelClone.id], txn: transaction)) {
        modelClone.createdAt ??= DateTime.now();
        await transaction.insert(tableName, modelClone.toMap());
      } else {
        await transaction.update(tableName, modelClone.toMap(), where: '${Model.idColumnName} = ?', whereArgs: [modelClone.id]);
      }

      for (final repository in childrenRepositories) {
        for (final childModel in repository.childrenModels(modelClone)) {
          await repository.upsert(childModel, txn: transaction);
        }
      }
    }

    if (txn == null) {
      await databaseLocal.transactionInstance().openTransaction((newTransaction) => fun(newTransaction));
    } else {
      await fun(txn);
    }

    return modelClone;
  }

  @override
  Future<T> insert(T model, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      return await databaseLocal.transactionInstance().openTransaction((newTransaction) => upsert(model, txn: newTransaction));
    } else {
      return await upsert(model, txn: txn);
    }
  }

  @override
  Future<T> update(T model, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      return await databaseLocal.transactionInstance().openTransaction((newTransaction) => upsert(model, txn: newTransaction));
    } else {
      return await upsert(model, txn: txn);
    }
  }

  @override
  Future<void> delete(T model, {ITransactionExecutor? txn}) async {
    final T modelClone = model.clone() as T;

    fun(ITransactionExecutor transaction) async {
      modelClone.createdAt ??= DateTime.now();
      modelClone.deletedAt ??= DateTime.now();

      await transaction.update(tableName, modelClone.toMap(), where: '${Model.idColumnName} = ?', whereArgs: [modelClone.id]);

      for (final repository in childrenRepositories) {
        for (final childModel in repository.childrenModels(modelClone)) {
          await repository.delete(childModel, txn: transaction);
        }
      }
    }

    if (txn == null) {
      await databaseLocal.transactionInstance().openTransaction((newTransaction) => fun(newTransaction));
    } else {
      await fun(txn);
    }
  }

  @override
  Future<bool> exists({required String where, List? whereArgs, ITransactionExecutor? txn}) async => (await (txn ?? databaseLocal).query(tableName, where: where, whereArgs: whereArgs, limit: 1)).firstOrNull != null;

  @override
  Future<T?> findOne({ITransactionExecutor? txn}) async => (await selectFull(limit: 1, txn: txn)).firstOrNull;

  @override
  Future<T?> findById(String id, {bool deleted = false, ITransactionExecutor? txn}) async => (await selectFull(id: id, deleted: deleted, limit: 1, txn: txn)).firstOrNull;

  @override
  Future<List<T>> findAll({bool deleted = false, ITransactionExecutor? txn}) => selectFull(deleted: deleted, txn: txn);

  Future<List<T>> selectFull({String? id, bool deleted = false, String? where, List<dynamic>? whereArgs, String? orderBy, int? offset, int? limit, ITransactionExecutor? txn}) async {
    List<String> whereListed = [];
    whereArgs ??= [];

    if (where?.isNotEmpty == true) {
      whereListed.add(where!);
    }

    if (id != null) {
      whereListed.add('${Model.idColumnName} = ?');
      whereArgs.add(id);
    }

    if (!deleted) {
      whereListed.add('${Model.deletedAtColumnName} IS NULL');
    }

    final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).query(
      tableName,
      where: whereListed.join(' AND '),
      whereArgs: whereArgs,
      orderBy: orderBy ?? orderByDefault,
      limit: limit,
      offset: offset,
    );

    return results.map((result) => fromMap(result)).toList();
  }
}
