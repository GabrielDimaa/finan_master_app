import 'package:finan_master_app/shared/infra/data_sources/exceptions/local_data_source_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class LocalDataSource<T extends Model> implements ILocalDataSource<T> {
  final IDatabaseLocal databaseLocal;
  final List<ILocalDataSource> childrenRepositories;

  LocalDataSource({
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

  ({String id, DateTime? createdAt, DateTime? deletedAt}) baseFromMap(Map<String, dynamic> map, {String prefix = ''}) {
    return (
      id: map['$prefix${Model.idColumnName}'],
      createdAt: DateTime.tryParse(map['$prefix${Model.createdAtColumnName}'].toString())?.toLocal(),
      deletedAt: DateTime.tryParse(map['$prefix${Model.deletedAtColumnName}'].toString())?.toLocal(),
    );
  }

  String get orderByDefault => '${Model.createdAtColumnName} ASC';

  @override
  List<T> childrenModels(dynamic model) => [];

  @override
  Future<T> upsert(T model, {ITransactionExecutor? txn}) async {
    try {
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
    } on DatabaseException catch (e, stackTrace) {
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
    try {
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
    } on DatabaseException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<bool> exists({required String where, List? whereArgs, ITransactionExecutor? txn}) async {
    try {
      return (await (txn ?? databaseLocal).query(tableName, where: where, whereArgs: whereArgs, limit: 1)).firstOrNull != null;
    } on DatabaseException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<T?> findOne({ITransactionExecutor? txn}) async => (await selectFull(limit: 1, txn: txn)).firstOrNull;

  @override
  Future<T?> findById(String id, {bool deleted = false, ITransactionExecutor? txn}) async => (await selectFull(id: id, deleted: deleted, limit: 1, txn: txn)).firstOrNull;

  @override
  Future<List<T>> findAll({bool deleted = false, ITransactionExecutor? txn}) => selectFull(deleted: deleted, txn: txn);

  Future<List<T>> selectFull({String? id, bool deleted = false, String? where, List<dynamic>? whereArgs, String? orderBy, int? offset, int? limit, ITransactionExecutor? txn}) async {
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
        where: whereListed.join(' AND '),
        whereArgs: whereArgs,
        orderBy: orderBy ?? orderByDefault,
        limit: limit,
        offset: offset,
      );

      return results.map((result) => fromMap(result)).toList();
    } on DatabaseException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  static LocalDataSourceException throwable(DatabaseException e, StackTrace stackTrace) {
    final int? code = e.getResultCode();

    if (code == 2067) return LocalDataSourceException(R.strings.registeredData, code, stackTrace);

    final List<String> clearMessages = [
      'SqliteException($code): ',
      ', constraint failed (code $code)',
      '(code $code SQLITE_CONSTRAINT_TRIGGER)',
      '(code $code SQLITE_CONSTRAINT_TRIGGER[$code])',
      'Error Domain=FMDatabase Code=$code',
      '(code $code)',
    ];

    String message = e.toString();

    for (var clean in clearMessages) {
      message = message.replaceAll(clean, '');
    }

    return LocalDataSourceException(message, code, stackTrace);
  }
}
