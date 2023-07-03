import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final class DatabaseLocal {
  String get _name => "finan_master.db";
  int get _version => 1;
  Database? _database;

  DatabaseLocal? _instance;

  DatabaseLocal._();

  DatabaseLocal getInstance() {
    _instance ??= DatabaseLocal._();
    return _instance!;
  }

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      await _getPath(),
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    await _database?.execute("VACUUM;");

    return _database!;
  }

  Future<File> getFileDatabase() async {
    //A conexão deve ser fechada antes de obter o arquivo do banco de dados.
    await _closeDatabase();
    final String path = await _getPath();

    return File(path);
  }

  Future<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    // TODO: Create tables.

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: Create migrations.
  }

  Future<void> _closeDatabase() async {
    await _database?.close();
    _database = null;
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
      if (e is SqfliteFfiException) '\n Causing statement: ${e.details?['sql']}',
    ];

    if (e is SqfliteDatabaseException) {
      String? message = e.message;

      for (var clean in clearMessages) {
        message = message?.replaceAll(clean, '');
      }

      throw Exception(message);
    }

    throw e;
  }
}
