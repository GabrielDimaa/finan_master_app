import 'dart:io';

import 'package:finan_master_app/features/account/infra/data_sources/account_local_data_source.dart';
import 'package:finan_master_app/features/auth/infra/data_sources/auth_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/data_sources/category_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/first_steps/infra/data_sources/first_steps_local_data_source.dart';
import 'package:finan_master_app/features/statement/infra/data_sources/statement_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/transfer_local_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/user_account_local_data_source.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

final class DatabaseLocal implements IDatabaseLocal {
  String get _name => "finan_master.db";

  int get _version => 8;

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

  void dispose() {
    database.close();
    _instance = null;
  }

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
      batch.execute('''
        CREATE TABLE first_steps (
          id TEXT NOT NULL PRIMARY KEY,
          created_at TEXT NOT NULL,
          deleted_at TEXT,
          account_step_done INTEGER NOT NULL DEFAULT 0,
          credit_card_step_done INTEGER NOT NULL DEFAULT 0,
          income_step_done INTEGER NOT NULL DEFAULT 0,
          expense_step_done INTEGER NOT NULL DEFAULT 0
        );
      ''');

      batch.insert('first_steps', {
        'id': const Uuid().v1(),
        'created_at': DateTime.now().toIso8601String(),
        'account_step_done': 1,
        'credit_card_step_done': 1,
        'income_step_done': 1,
        'expense_step_done': 1,
      });
    }

    if (oldVersion < 3) {
      final result = await db.rawQuery('''
        SELECT
          credit_card_transactions.id AS credit_card_transactions_id,
          credit_card_transactions.created_at AS credit_card_transactions_created_at,
          credit_card_transactions.deleted_at AS credit_card_transactions_deleted_at,
          credit_card_transactions.description AS credit_card_transactions_description,
          credit_card_transactions.amount AS credit_card_transactions_amount,
          credit_card_transactions.date AS credit_card_transactions_date,
          credit_card_transactions.id_category AS credit_card_transactions_id_category,
          credit_card_transactions.id_credit_card AS credit_card_transactions_id_credit_card,
          credit_card_transactions.id_credit_card_bill AS credit_card_transactions_id_credit_card_bill,
          credit_card_transactions.observation AS credit_card_transactions_observation
        FROM credit_card_transactions
        INNER JOIN credit_card_bills
          ON credit_card_bills.id = credit_card_transactions.id_credit_card_bill
        WHERE 
          credit_card_bills.paid = 1 AND
          credit_card_transactions.amount > 0 AND
          credit_card_transactions.deleted_at IS NULL AND
          credit_card_bills.deleted_at IS NULL;
      ''');

      if (result.isNotEmpty) {
        batch.execute(
          '''
            UPDATE expenses
            SET deleted_at = ?
            WHERE id_credit_card_transaction IN (${result.map((e) => '?').join(',')});
          ''',
          [DateTime.now().toIso8601String(), ...result.map((e) => e['credit_card_transactions_id'])],
        );

        batch.execute(
          '''
            UPDATE transactions
            SET deleted_at = ?
            WHERE id IN (
                SELECT id_transaction 
                FROM expenses
                WHERE id_credit_card_transaction IN (${result.map((e) => '?').join(',')})
            );
          ''',
          [DateTime.now().toIso8601String(), ...result.map((e) => e['credit_card_transactions_id'])],
        );

        final billPayments = await db.rawQuery('''
          SELECT
            credit_card_transactions.id AS credit_card_transactions_id,
            credit_card_transactions.created_at AS credit_card_transactions_created_at,
            credit_card_transactions.deleted_at AS credit_card_transactions_deleted_at,
            credit_card_transactions.description AS credit_card_transactions_description,
            credit_card_transactions.amount AS credit_card_transactions_amount,
            credit_card_transactions.date AS credit_card_transactions_date,
            credit_card_transactions.id_category AS credit_card_transactions_id_category,
            credit_card_transactions.id_credit_card AS credit_card_transactions_id_credit_card,
            credit_card_transactions.id_credit_card_bill AS credit_card_transactions_id_credit_card_bill,
            credit_card_transactions.observation AS credit_card_transactions_observation,
            account.id_account AS id_account
          FROM credit_card_transactions
          INNER JOIN credit_card_bills
            ON credit_card_bills.id = credit_card_transactions.id_credit_card_bill
          INNER JOIN credit_cards
            ON credit_cards.id = credit_card_bills.id_credit_card
          INNER JOIN (
              SELECT 
                id_account, 
                id_credit_card_bill
              FROM expenses
              INNER JOIN credit_card_transactions
                ON expenses.id_credit_card_transaction = credit_card_transactions.id
              INNER JOIN transactions
                ON expenses.id_transaction = transactions.id
              GROUP BY credit_card_transactions.id_credit_card_bill
          ) AS account
            ON account.id_credit_card_bill = credit_card_bills.id
          WHERE
            credit_card_bills.paid = 1 AND
            credit_card_transactions.amount < 0 AND
            credit_card_transactions.deleted_at IS NULL AND
            credit_card_bills.deleted_at IS NULL AND
            NOT EXISTS (
              SELECT 1
              FROM expenses
              WHERE expenses.id_credit_card_transaction = credit_card_transactions.id
            );
        ''');

        for (final billPayment in billPayments) {
          final idTransaction = const Uuid().v1();
          final createdAt = DateTime.now().toIso8601String();

          batch.execute(
            '''
              INSERT INTO expenses (id, created_at, description, id_category, id_credit_card_transaction, id_transaction, observation)
              VALUES (?, ?, ?, ?, ?, ?, ?);
            ''',
            [
              const Uuid().v1(),
              createdAt,
              billPayment['credit_card_transactions_description'],
              billPayment['credit_card_transactions_id_category'],
              billPayment['credit_card_transactions_id'],
              idTransaction,
              billPayment['credit_card_transactions_observation'],
            ],
          );

          batch.execute(
            '''
              INSERT INTO transactions (id, created_at, amount, type, date, id_account)
              VALUES (?, ?, ?, ?, ?, ?);
            ''',
            [
              idTransaction,
              createdAt,
              billPayment['credit_card_transactions_amount'],
              1,
              billPayment['credit_card_transactions_date'],
              billPayment['id_account'],
            ],
          );
        }

        batch.execute('ALTER TABLE credit_card_bills DROP COLUMN paid;');

        batch.execute('''
          CREATE TABLE statements (
            id TEXT NOT NULL PRIMARY KEY,
            created_at TEXT NOT NULL,
            deleted_at TEXT,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            id_account TEXT NOT NULL REFERENCES accounts(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            id_expense TEXT REFERENCES expenses(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            id_income TEXT REFERENCES incomes(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            id_transfer TEXT REFERENCES transfers(incomes) ON UPDATE CASCADE ON DELETE RESTRICT
          );
        ''');

        batch.execute('''
          INSERT INTO statements (id, created_at, deleted_at, amount, date, id_account, id_expense, id_income, id_transfer)
            SELECT
              transactions.id,
              transactions.created_at,
              transactions.deleted_at,
              transactions.amount,
              transactions.date,
              transactions.id_account,
              expenses.id,
              incomes.id,
              COALESCE(transfers_from.id, transfers_to.id)
            FROM transactions
            LEFT JOIN expenses
              ON transactions.id = expenses.id_transaction
            LEFT JOIN incomes
              ON transactions.id = incomes.id_transaction
            LEFT JOIN transfers AS transfers_from
              ON transactions.id = transfers_from.id_transaction_from
            LEFT JOIN transfers AS transfers_to
              ON transactions.id = transfers_to.id_transaction_to;
        ''');

        batch.execute('ALTER TABLE expenses ADD COLUMN paid INTEGER NOT NULL DEFAULT 1;');
        batch.execute('ALTER TABLE incomes ADD COLUMN received INTEGER NOT NULL DEFAULT 1;');

        batch.execute('''
          CREATE TABLE expenses_new (
            id TEXT NOT NULL PRIMARY KEY,
            created_at TEXT NOT NULL,
            deleted_at TEXT,
            description TEXT NOT NULL,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            paid INTEGER NOT NULL DEFAULT 1,
            id_account TEXT NOT NULL REFERENCES accounts(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            id_category TEXT NOT NULL REFERENCES categories(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            id_credit_card TEXT REFERENCES credit_cards(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            id_credit_card_transaction TEXT REFERENCES credit_card_transactions(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            observation TEXT
          );
        ''');

        batch.execute('''
          INSERT INTO expenses_new (id, created_at, deleted_at, description, amount, date, paid, id_account, id_category, id_credit_card, id_credit_card_transaction, observation)
            SELECT
              expenses.id,
              expenses.created_at,
              expenses.deleted_at,
              expenses.description,
              transactions.amount,
              transactions.date,
              1,
              transactions.id_account,
              expenses.id_category,
              credit_card_transactions.id_credit_card,
              credit_card_transactions.id,
              expenses.observation
            FROM expenses
            INNER JOIN transactions
              ON expenses.id_transaction = transactions.id
            LEFT JOIN credit_card_transactions
              ON expenses.id_credit_card_transaction = credit_card_transactions.id;
        ''');

        batch.execute('''
          CREATE TABLE incomes_new (
            id TEXT NOT NULL PRIMARY KEY,
            created_at TEXT NOT NULL,
            deleted_at TEXT,
            description TEXT NOT NULL,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            received INTEGER NOT NULL DEFAULT 1,
            id_account TEXT NOT NULL REFERENCES accounts(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            id_category TEXT NOT NULL REFERENCES categories(id) ON UPDATE CASCADE ON DELETE RESTRICT,
            observation TEXT
          );
        ''');

        batch.execute('''
          INSERT INTO incomes_new (id, created_at, deleted_at, description, amount, date, received, id_account, id_category, observation)
            SELECT
              incomes.id,
              incomes.created_at,
              incomes.deleted_at,
              incomes.description,
              transactions.amount,
              transactions.date,
              1,
              transactions.id_account,
              incomes.id_category,
              incomes.observation
            FROM incomes
            INNER JOIN transactions
              ON incomes.id_transaction = transactions.id;
        ''');

        batch.execute('''
          CREATE TABLE transfers_mew (
            id TEXT NOT NULL PRIMARY KEY,
            created_at TEXT NOT NULL,
            deleted_at TEXT,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            id_account_from TEXT NOT NULL REFERENCES accounts(id) ON UPDATE CASCADE ON DELETE CASCADE,
            id_account_to TEXT NOT NULL REFERENCES accounts(id) ON UPDATE CASCADE ON DELETE CASCADE
          );
        ''');

        batch.execute('''
          INSERT INTO transfers_mew (id, created_at, deleted_at, amount, date, id_account_from, id_account_to)
            SELECT
              transfers.id,
              transfers.created_at,
              transfers.deleted_at,
              transactions_to.amount,
              transactions_to.date,
              transactions_from.id_account,
              transactions_to.id_account
            FROM transfers
            INNER JOIN transactions transactions_from
              ON transfers.id_transaction_from = transactions_from.id
            INNER JOIN transactions transactions_to
              ON transfers.id_transaction_to = transactions_to.id;
        ''');

        batch.execute('DROP TABLE transactions;');

        batch.execute('DROP TABLE expenses;');
        batch.execute('ALTER TABLE expenses_new RENAME TO expenses;');

        batch.execute('DROP TABLE incomes;');
        batch.execute('ALTER TABLE incomes_new RENAME TO incomes;');

        batch.execute('DROP TABLE transfers;');
        batch.execute('ALTER TABLE transfers_mew RENAME TO transfers;');

        batch.execute('''
          INSERT INTO categories (id, created_at, deleted_at, description, type, color, icon)
          VALUES ('00000000-0000-0000-0000-000000000002', ?, ?, ?, 1, 'FF46A66C', ?);
        ''', [DateTime.now().toIso8601String(), DateTime.now().toIso8601String(), R.strings.creditCard, Icons.credit_score_outlined.codePoint]);

        batch.execute('''
          UPDATE expenses
          SET id_category = '00000000-0000-0000-0000-000000000002'
          WHERE id_credit_card_transaction IS NOT NULL;
        ''');
      }

      await batch.commit();
    }
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
