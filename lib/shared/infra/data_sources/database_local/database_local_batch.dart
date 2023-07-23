import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final class DatabaseLocalBatch implements IDatabaseLocalBatch {
  late final Batch _batch;

  DatabaseLocalBatch({required Database database, Transaction? txn}) {
    _batch = (txn ?? database).batch();
  }

  @override
  Future<void> commit() async {
    try {
      await _batch.commit(noResult: false);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

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
}
