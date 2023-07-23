import 'dart:io';

import 'package:finan_master_app/features/category/infra/data_sources/category_data_source.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final class DatabaseLocal implements IDatabaseLocal {
  String get _name => "finan_master.db";

  int get _version => 1;

  late Database database;

  static DatabaseLocal? _instance;

  DatabaseLocal._();

  static Future<DatabaseLocal> getInstance() async {
    if (_instance != null) return _instance!;

    _instance ??= DatabaseLocal._();

    if (Platform.isWindows) sqfliteFfiInit();

    await _instance?._loadDatabase();
    await _instance?.database.execute("VACUUM;");

    return _instance!;
  }

  Future<File> getFileDatabase() async {
    //A conexão deve ser fechada antes de obter o arquivo do banco de dados.
    await database.close();
    final String path = await _getPath();
    await _loadDatabase();

    return File(path);
  }

  Future<void> _loadDatabase() async {
    if (Platform.isWindows) databaseFactoryOrNull = databaseFactoryFfi;

    database = await openDatabase(
      await _getPath(),
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final IDatabaseLocalBatch batch = DatabaseLocalBatch(database: db);

    CategoryDataSource(databaseLocal: this).createTable(batch);

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: Create migrations.
  }

  Future<String> _getPath() async {
    final String databasesPath = await getDatabasesPath();

    final String path = join(databasesPath, _name);
    await Directory(databasesPath).create(recursive: true);

    return path;
  }

  @override
  IDatabaseLocalBatch batch() => DatabaseLocalBatch(database: database);

  @override
  IDatabaseLocalTransaction transactionInstance() => DatabaseLocalTransaction(database: database);

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    try {
      return await database.insert(table, values);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs}) async {
    try {
      return await database.update(table, values, where: where, whereArgs: whereArgs);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    try {
      return await database.delete(table, where: where, whereArgs: whereArgs);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future<dynamic> execute(String sql, [List<dynamic>? arguments]) async {
    try {
      return await database.execute(sql, arguments);
    } on DatabaseException catch (e, stackTrace) {
      throw DatabaseLocalException(e.toString(), e.getResultCode(), stackTrace);
    }
  }

  @override
  Future<dynamic> raw(String sql, DatabaseOperation operation, [List<dynamic>? arguments]) {
    try {
      switch (operation) {
        case DatabaseOperation.select:
          return database.rawQuery(sql, arguments);
        case DatabaseOperation.insert:
          return database.rawInsert(sql, arguments);
        case DatabaseOperation.update:
          return database.rawUpdate(sql, arguments);
        case DatabaseOperation.delete:
          return database.rawDelete(sql, arguments);
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
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      return await database.query(
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
