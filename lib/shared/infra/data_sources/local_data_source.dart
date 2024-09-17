import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/exceptions/local_data_source_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

abstract class LocalDataSource<T extends Model> implements ILocalDataSource<T> {
  final IDatabaseLocal databaseLocal;
  final List<ILocalDataSource> childrenRepositories;

  LocalDataSource({
    required this.databaseLocal,
    this.childrenRepositories = const [],
  });

  static const String separator = '~!@#%^&*()?';

  String baseColumnsSql() => LocalDataSourceUtils.baseColumnsSql();

  ({String id, DateTime? createdAt, DateTime? deletedAt}) baseFromMap(Map<String, dynamic> map, {String prefix = ''}) => LocalDataSourceUtils.baseFromMap(map, prefix: prefix);

  String get orderByDefault => '${Model.createdAtColumnName} ASC';

  @override
  List<T> childrenModels(dynamic model) => [];

  @override
  Future<T> upsert(T model, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      return await databaseLocal.transactionInstance().openTransaction((newTransaction) => upsert(model, txn: newTransaction));
    }

    try {
      final T modelClone = model.clone() as T;

      if (!await exists(where: '${Model.idColumnName} = ?', whereArgs: [modelClone.id], txn: txn)) {
        modelClone.createdAt ??= DateTime.now();
        await txn.insert(tableName, modelClone.toMap());
      } else {
        await txn.update(tableName, modelClone.toMap(), where: '${Model.idColumnName} = ?', whereArgs: [modelClone.id]);
      }

      for (final repository in childrenRepositories) {
        for (final childModel in repository.childrenModels(modelClone)) {
          await repository.upsert(childModel, txn: txn);
        }
      }

      return modelClone;
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
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
    if (txn == null) {
      return await databaseLocal.transactionInstance().openTransaction((newTransaction) => delete(model, txn: newTransaction));
    }

    try {
      final T modelClone = model.clone() as T;

      modelClone.createdAt ??= DateTime.now();
      modelClone.deletedAt ??= DateTime.now();

      await txn.update(tableName, modelClone.toMap(), where: '${Model.idColumnName} = ?', whereArgs: [modelClone.id]);

      for (final repository in childrenRepositories) {
        for (final childModel in repository.childrenModels(modelClone)) {
          await repository.delete(childModel, txn: txn);
        }
      }
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<bool> exists({required String where, List? whereArgs, ITransactionExecutor? txn}) async {
    try {
      return (await (txn ?? databaseLocal).query(tableName, where: where, whereArgs: whereArgs, limit: 1)).firstOrNull != null;
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<T?> findOne({String? where, List<dynamic>? whereArgs, bool deleted = false, ITransactionExecutor? txn}) async => (await selectFull(where: where, whereArgs: whereArgs, deleted: deleted, limit: 1, txn: txn)).firstOrNull;

  @override
  Future<T?> findById(String id, {bool deleted = false, ITransactionExecutor? txn}) async => (await selectFull(id: id, deleted: deleted, limit: 1, txn: txn)).firstOrNull;

  @override
  Future<List<T>> findAll({String? where, List<dynamic>? whereArgs, bool deleted = false, ITransactionExecutor? txn}) => selectFull(where: where, whereArgs: whereArgs, deleted: deleted, txn: txn);

  Future<List<T>> selectFull({String? id, bool deleted = false, String? where, List<dynamic>? whereArgs, String? orderBy, int? offset, int? limit, String? groupBy, ITransactionExecutor? txn}) async {
    try {
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
        where: whereListed.isNotEmpty ? whereListed.join(' AND ') : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: orderBy ?? orderByDefault,
        limit: limit,
        offset: offset,
        groupBy: groupBy,
      );

      return results.map((result) => fromMap(result)).toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  LocalDataSourceException throwable(DatabaseLocalException e, StackTrace stackTrace) => LocalDataSourceUtils.throwable(e, stackTrace);
}

abstract class LocalDataSourceUtils {
  static String baseColumnsSql() {
    return '''
      ${Model.idColumnName} TEXT NOT NULL PRIMARY KEY,
      ${Model.createdAtColumnName} TEXT NOT NULL,
      ${Model.deletedAtColumnName} TEXT
    ''';
  }

  static ({String id, DateTime? createdAt, DateTime? deletedAt}) baseFromMap(Map<String, dynamic> map, {String prefix = ''}) {
    return (
    id: map['$prefix${Model.idColumnName}'],
    createdAt: DateTime.tryParse(map['$prefix${Model.createdAtColumnName}'].toString())?.toLocal(),
    deletedAt: DateTime.tryParse(map['$prefix${Model.deletedAtColumnName}'].toString())?.toLocal(),
    );
  }

  static LocalDataSourceException throwable(DatabaseLocalException e, StackTrace stackTrace) {
    if (e.code == 2067) return LocalDataSourceException(R.strings.registeredData, e.code, stackTrace);

    final List<String> clearMessages = [
      'SqliteException(${e.code}): ',
      ', constraint failed (code ${e.code})',
      '(code ${e.code} SQLITE_CONSTRAINT_TRIGGER)',
      '(code ${e.code} SQLITE_CONSTRAINT_TRIGGER[${e.code}])',
      'Error Domain=FMDatabase Code=${e.code}',
      '(code ${e.code})',
    ];

    String message = e.toString();

    for (var clean in clearMessages) {
      message = message.replaceAll(clean, '');
    }

    return LocalDataSourceException(message, e.code, stackTrace);
  }
}