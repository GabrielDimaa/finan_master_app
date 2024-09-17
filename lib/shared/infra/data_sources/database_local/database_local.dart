import 'dart:io';

import 'package:finan_master_app/features/account/infra/data_sources/account_local_data_source.dart';
import 'package:finan_master_app/features/auth/infra/data_sources/auth_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/data_sources/category_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/first_steps/domain/entities/first_steps_entity.dart';
import 'package:finan_master_app/features/first_steps/helpers/first_steps_factory.dart';
import 'package:finan_master_app/features/first_steps/infra/data_sources/first_steps_local_data_source.dart';
import 'package:finan_master_app/features/statement/infra/data_sources/statement_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/transfer_local_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/user_account_local_data_source.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final class DatabaseLocal implements IDatabaseLocal {
  String get _name => "finan_master.db";

  int get _version => 3;

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

  void dispose() => _instance = null;

  @override
  Future<File> getFileDatabase() async {
    //A conexão deve ser fechada antes de obter o arquivo do banco de dados.
    await database.close();
    final String path = await _getPath();
    await _loadDatabase();

    return File(path);
  }

  @override
  Future<void> deleteFileDatabase() async {
    //A conexão deve ser fechada antes de obter o arquivo do banco de dados.
    await database.close();

    final String path = await _getPath();
    final File fileDatabaseLocal = File(path);

    if (await fileDatabaseLocal.exists()) await fileDatabaseLocal.delete();

    await _loadDatabase();
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

    CategoryLocalDataSource(databaseLocal: this).createTable(batch);
    AccountLocalDataSource(databaseLocal: this).createTable(batch);
    StatementLocalDataSource(databaseLocal: this).createTable(batch);
    ExpenseLocalDataSource(databaseLocal: this).createTable(batch);
    IncomeLocalDataSource(databaseLocal: this).createTable(batch);
    TransferLocalDataSource(databaseLocal: this).createTable(batch);
    final CreditCardTransactionLocalDataSource creditCardTransactionLocalDataSource = CreditCardTransactionLocalDataSource(databaseLocal: this)..createTable(batch);
    final ICreditCardBillLocalDataSource creditCardBillLocalDataSource = CreditCardBillLocalDataSource(databaseLocal: this, creditCardTransactionLocalDataSource: creditCardTransactionLocalDataSource)..createTable(batch);
    CreditCardLocalDataSource(databaseLocal: this, creditCardBillLocalDataSource: creditCardBillLocalDataSource).createTable(batch);
    AuthLocalDataSource(databaseLocal: this).createTable(batch);
    UserAccountLocalDataSource(databaseLocal: this).createTable(batch);
    FirstStepsLocalDataSource(databaseLocal: this).createTable(batch);

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final IDatabaseLocalBatch batch = DatabaseLocalBatch(database: db);

    if (oldVersion < 2) {
      FirstStepsLocalDataSource(databaseLocal: this).createTable(batch);

      final FirstStepsEntity entity = FirstStepsFactory.newEntity()
        ..done = true
        ..createdAt = DateTime.now();

      batch.insert(FirstStepsLocalDataSource(databaseLocal: this).tableName, FirstStepsFactory.fromEntity(entity).toMap());
    }

    if (oldVersion < 3) {
      batch.execute('ALTER TABLE $expensesTableName ADD COLUMN paid INTEGER NOT NULL DEFAULT 1;');
      batch.execute('ALTER TABLE $incomesTableName ADD COLUMN paid INTEGER NOT NULL DEFAULT 1;');
    }

    await batch.commit();
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
