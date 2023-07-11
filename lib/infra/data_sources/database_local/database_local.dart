import 'dart:io';

import 'package:finan_master_app/infra/data_sources/database_local/database_local_batch.dart';
import 'package:finan_master_app/infra/data_sources/database_local/database_local_transaction.dart';
import 'package:finan_master_app/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final class DatabaseLocal implements IDatabaseLocal {
  String get _name => "finan_master.db";

  int get _version => 1;

  late Database _database;

  static DatabaseLocal? _instance;

  DatabaseLocal._();

  static Future<DatabaseLocal> getInstance() async {
    if (_instance != null) return _instance!;

    _instance ??= DatabaseLocal._();

    if (Platform.isWindows) sqfliteFfiInit();

    await _instance?._loadDatabase();
    await _instance?._database.execute("VACUUM;");

    return _instance!;
  }

  Future<File> getFileDatabase() async {
    //A conexão deve ser fechada antes de obter o arquivo do banco de dados.
    await _database.close();
    final String path = await _getPath();
    await _loadDatabase();

    return File(path);
  }

  Future<void> _loadDatabase() async {
    if (Platform.isWindows) databaseFactoryOrNull = databaseFactoryFfi;

    _database = await openDatabase(
      await _getPath(),
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    // TODO: Create tables.

    await batch.commit(noResult: true);
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

  static throwable(DatabaseException e, StackTrace st, String tableName) {
    final int? code = e.getResultCode();

    if (code == 2067) throw Exception("Dado já cadastrado.");

    final List<String> clearMessages = [
      'SqliteException($code): ',
      ', constraint failed (code $code)',
      '(code $code SQLITE_CONSTRAINT_TRIGGER)',
      '(code $code SQLITE_CONSTRAINT_TRIGGER[$code])',
      'Error Domain=FMDatabase Code=$code',
      '(code $code)',
    ];

    String? message = e.toString();

    for (var clean in clearMessages) {
      message = message?.replaceAll(clean, '');
    }

    throw Exception(message);
  }

  @override
  IDatabaseLocalBatch get batch => DatabaseLocalBatch(database: _database);

  @override
  IDatabaseLocalTransaction get transaction => DatabaseLocalTransaction(database: _database);

  @override
  Future<int> insert(String table, Map<String, dynamic> values) => _database.insert(table, values);

  @override
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs}) => _database.update(table, values, where: where, whereArgs: whereArgs);

  @override
  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) => _database.delete(table, where: where, whereArgs: whereArgs);

  @override
  Future<dynamic> execute(String sql, [List<dynamic>? arguments]) => _database.execute(sql, arguments);

  @override
  Future<dynamic> raw(String sql, DatabaseOperation operation, [List<dynamic>? arguments]) {
    switch (operation) {
      case DatabaseOperation.select:
        return _database.rawQuery(sql, arguments);
      case DatabaseOperation.insert:
        return _database.rawInsert(sql, arguments);
      case DatabaseOperation.update:
        return _database.rawUpdate(sql, arguments);
      case DatabaseOperation.delete:
        return _database.rawDelete(sql, arguments);
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
  }) =>
      _database.query(
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
