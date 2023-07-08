import 'package:finan_master_app/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_batch.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final class DatabaseBatch implements IDatabaseBatch {
  final Database _database;
  late final Batch _batch;

  DatabaseBatch(this._database) {
    _batch = _database.batch();
  }

  @override
  Future<List<Object?>> commit() => _batch.commit();

  @override
  void insert(String table, Map<String, dynamic> values) => _batch.insert(table, values);

  @override
  void update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs}) => _batch.update(table, values, where: where, whereArgs: whereArgs);

  @override
  void delete(String table, {String? where, List<dynamic>? whereArgs}) => _batch.delete(table, where: where, whereArgs: whereArgs);

  @override
  void execute(String sql, [List<dynamic>? arguments]) => _batch.execute(sql, arguments);

  @override
  void raw(String sql, DatabaseOperation operation, [List<dynamic>? arguments]) {
    switch (operation) {
      case DatabaseOperation.select:
        return _batch.rawQuery(sql, arguments);
      case DatabaseOperation.insert:
        return _batch.rawInsert(sql, arguments);
      case DatabaseOperation.update:
        return _batch.rawUpdate(sql, arguments);
      case DatabaseOperation.delete:
        return _batch.rawDelete(sql, arguments);
    }
  }

  @override
  void query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      _batch.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
}
