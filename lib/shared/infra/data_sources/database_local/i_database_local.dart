import 'dart:io';

import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class IDatabaseLocal {
  Future<File> getFileDatabase();

  IDatabaseLocalBatch batch();

  IDatabaseLocalTransaction transactionInstance();

  Future<int> insert(String table, Map<String, dynamic> values);

  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs});

  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs});

  Future<void> execute(String sql, [List<dynamic>? arguments]);

  Future<dynamic> raw(String sql, DatabaseOperation operation, [List<dynamic>? arguments]);

  Future<List<Map<String, dynamic>>> query(
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
  });
}
