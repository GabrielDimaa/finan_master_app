import 'dart:async';

import 'package:finan_master_app/infra/data_sources/database_local/database_local_batch.dart';
import 'package:finan_master_app/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLocalTransaction implements IDatabaseLocalTransaction, ITransactionExecutor {
  final Database _database;

  DatabaseLocalTransaction({required Database database}) : _database = database;

  late Transaction _txn;

  @override
  Future<T> openTransaction<T>(ActionTxn<T> action) async {
    return await _database.transaction<T>((txn) async {
      _txn = txn;
      return await action(this);
    });
  }

  @override
  IDatabaseLocalBatch batch() => DatabaseLocalBatch(database: _txn.database, txn: _txn);

  @override
  IDatabaseLocalTransaction transactionInstance() => DatabaseLocalTransaction(database: _database);

  @override
  Future<int> insert(String table, Map<String, dynamic> values) => _txn.insert(table, values);

  @override
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List? whereArgs}) => _txn.update(table, values, where: where, whereArgs: whereArgs);

  @override
  Future<int> delete(String table, {String? where, List? whereArgs}) => _txn.delete(table, where: where, whereArgs: whereArgs);

  @override
  Future<void> execute(String sql, [List? arguments]) => _txn.execute(sql, arguments);

  @override
  Future raw(String sql, DatabaseOperation operation, [List? arguments]) {
    switch (operation) {
      case DatabaseOperation.select:
        return _txn.rawQuery(sql, arguments);
      case DatabaseOperation.insert:
        return _txn.rawInsert(sql, arguments);
      case DatabaseOperation.update:
        return _txn.rawUpdate(sql, arguments);
      case DatabaseOperation.delete:
        return _txn.rawDelete(sql, arguments);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      _txn.query(
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
