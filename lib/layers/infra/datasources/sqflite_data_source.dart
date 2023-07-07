import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqfliteDataSource {
  String get _name => "finan_master.db";
  int get _version => 1;

  Database? _database;

  SqfliteDataSource? _instance;

  SqfliteDataSource._();

  Future<SqfliteDataSource> getInstance() async {
    if (_instance != null) return _instance!;
    
    _instance ??= SqfliteDataSource._();
    
    await getDatabase();
    await _database?.execute("VACUUM;");
    
    return _instance!;
  }

  Future<File> getFileDatabase() async {
    //A conexão deve ser fechada antes de obter o arquivo do banco de dados.
    await _closeDatabase();
    final String path = await _getPath();

    return File(path);
  }

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    return await openDatabase(
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
    ];

    String? message = e.toString();

    for (var clean in clearMessages) {
      message = message?.replaceAll(clean, '');
    }

    throw Exception(message);
  }
}
