import 'dart:async';

import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
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
  Future<int> insert(String table, Map<String, dynamic> values) async {
    try {
      return await _txn.insert(table, values);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List? whereArgs}) async {
    try {
      return await _txn.update(table, values, where: where, whereArgs: whereArgs);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future<int> delete(String table, {String? where, List? whereArgs}) async {
    try {
      return await _txn.delete(table, where: where, whereArgs: whereArgs);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future<void> execute(String sql, [List? arguments]) async {
    try {
      return await _txn.execute(sql, arguments);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future raw(String sql, DatabaseOperation operation, [List? arguments]) async {
    try {
      switch (operation) {
        case DatabaseOperation.select:
          return await _txn.rawQuery(sql, arguments);
        case DatabaseOperation.insert:
          return await _txn.rawInsert(sql, arguments);
        case DatabaseOperation.update:
          return await _txn.rawUpdate(sql, arguments);
        case DatabaseOperation.delete:
          return await _txn.rawDelete(sql, arguments);
      }
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
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
  }) async {
    try {
      return await _txn.query(
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
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }
}
