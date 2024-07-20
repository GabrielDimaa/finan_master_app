import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/i_transaction_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransactionLocalDataSource extends LocalDataSource<TransactionModel> implements ITransactionLocalDataSource {
  late final IExpenseLocalDataSource _expenseLocalDataSource;
  late final IIncomeLocalDataSource _incomeLocalDataSource;
  late final ITransferLocalDataSource _transferLocalDataSource;

  TransactionLocalDataSource({required super.databaseLocal}) {
    _expenseLocalDataSource = ExpenseLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: this);
    _incomeLocalDataSource = IncomeLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: this);
    _transferLocalDataSource = TransferLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: this);
  }

  @override
  String get tableName => transactionsTableName;

  @override
  String get orderByDefault => '${tableName}_date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        amount REAL NOT NULL,
        type INTEGER NOT NULL,
        date TEXT NOT NULL,
        id_account TEXT NOT NULL REFERENCES $accountsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT
      );
    ''');
  }

  @override
  List<TransactionModel> childrenModels(model) {
    return switch (model.runtimeType) {
      ExpenseModel => [(model as ExpenseModel).transaction],
      IncomeModel => [(model as IncomeModel).transaction],
      TransferModel => [(model as TransferModel).transactionFrom, model.transactionTo],
      _ => [],
    };
  }

  @override
  TransactionModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return TransactionModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      amount: map['${prefix}amount'],
      type: TransactionTypeEnum.getByValue(map['${prefix}type'])!,
      date: DateTime.tryParse(map['${prefix}date'].toString())!.toLocal(),
      idAccount: map['${prefix}id_account'],
    );
  }

  @override
  Future<List<TransactionModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, ITransactionExecutor? txn}) async {
    try {
      List<String> whereListed = [];
      whereArgs ??= [];

      if (where?.isNotEmpty == true) {
        whereListed.add(where!);
      }

      if (id != null) {
        whereListed.add('${Model.idColumnName} = ?');
        whereArgs.add(id);
      }

      if (!deleted) {
        whereListed.add("$tableName.${Model.deletedAtColumnName} IS NULL");
      }

      final String sql = '''
        SELECT
          -- Transaction
          $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
          $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
          $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
          $tableName.amount AS ${tableName}_amount,
          $tableName.type AS ${tableName}_type,
          $tableName.date AS ${tableName}_date,
          $tableName.id_account AS ${tableName}_id_account
        FROM $tableName
        ${whereListed.isNotEmpty ? 'WHERE ${whereListed.join(' AND ')}' : ''}
        ORDER BY ${orderBy ?? orderByDefault}
        ${limit != null ? ' LIMIT $limit' : ''}
        ${offset != null ? ' OFFSET $offset' : ''};
      ''';

      final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).raw(sql, DatabaseOperation.select, whereArgs);

      return results.map((e) => fromMap(e, prefix: '${tableName}_')).toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<List<ITransactionModel>> findByPeriod({required DateTime startDate, required DateTime endDate}) async {
    final String sql = '''
      SELECT *
      FROM (
        SELECT
          -- Expense
          ${_expenseLocalDataSource.tableName}.${Model.idColumnName} AS ${_expenseLocalDataSource.tableName}_${Model.idColumnName},
          ${_expenseLocalDataSource.tableName}.${Model.createdAtColumnName} AS ${_expenseLocalDataSource.tableName}_${Model.createdAtColumnName},
          ${_expenseLocalDataSource.tableName}.${Model.deletedAtColumnName} AS ${_expenseLocalDataSource.tableName}_${Model.deletedAtColumnName},
          ${_expenseLocalDataSource.tableName}.description AS ${_expenseLocalDataSource.tableName}_description,
          ${_expenseLocalDataSource.tableName}.id_category AS ${_expenseLocalDataSource.tableName}_id_category,
          ${_expenseLocalDataSource.tableName}.id_credit_card_transaction AS ${_expenseLocalDataSource.tableName}_id_credit_card_transaction,
          ${_expenseLocalDataSource.tableName}.id_transaction AS ${_expenseLocalDataSource.tableName}_id_transaction,
          ${_expenseLocalDataSource.tableName}.observation AS ${_expenseLocalDataSource.tableName}_observation,
          
          -- Income
          NULL AS ${_incomeLocalDataSource.tableName}_${Model.idColumnName},
          NULL AS ${_incomeLocalDataSource.tableName}_${Model.createdAtColumnName},
          NULL AS ${_incomeLocalDataSource.tableName}_${Model.deletedAtColumnName},
          NULL AS ${_incomeLocalDataSource.tableName}_description,
          NULL AS ${_incomeLocalDataSource.tableName}_id_category,
          NULL AS ${_incomeLocalDataSource.tableName}_id_credit_card_transaction,
          NULL AS ${_incomeLocalDataSource.tableName}_id_transaction,
          NULL AS ${_incomeLocalDataSource.tableName}_observation,
          
          -- Transaction
          $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
          $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
          $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
          $tableName.amount AS ${tableName}_amount,
          $tableName.type AS ${tableName}_type,
          $tableName.date AS ${tableName}_date,
          $tableName.id_account AS ${tableName}_id_account,
          
          -- Transfers
          NULL AS ${_transferLocalDataSource.tableName}_${Model.idColumnName},
          NULL AS ${_transferLocalDataSource.tableName}_${Model.createdAtColumnName},
          NULL AS ${_transferLocalDataSource.tableName}_${Model.deletedAtColumnName},
          NULL AS ${_transferLocalDataSource.tableName}_id_transaction_from,
          NULL AS ${_transferLocalDataSource.tableName}_id_transaction_to,
          
          -- Transaction from
          NULL AS ${tableName}_from_${Model.idColumnName},
          NULL AS ${tableName}_from_${Model.createdAtColumnName},
          NULL AS ${tableName}_from_${Model.deletedAtColumnName},
          NULL AS ${tableName}_from_amount,
          NULL AS ${tableName}_from_type,
          NULL AS ${tableName}_from_date,
          NULL AS ${tableName}_from_id_account,
          
          -- Transaction to
          NULL AS ${tableName}_to_${Model.idColumnName},
          NULL AS ${tableName}_to_${Model.createdAtColumnName},
          NULL AS ${tableName}_to_${Model.deletedAtColumnName},
          NULL AS ${tableName}_to_amount,
          NULL AS ${tableName}_to_type,
          NULL AS ${tableName}_to_date,
          NULL AS ${tableName}_to_id_account
        FROM ${_expenseLocalDataSource.tableName}
        INNER JOIN $tableName
          ON $tableName.${Model.idColumnName} = ${_expenseLocalDataSource.tableName}.id_transaction
        WHERE
          $tableName.${Model.deletedAtColumnName} IS NULL AND
          $tableName.date BETWEEN ? AND ?
          
        UNION ALL
        
        SELECT
          -- Expense
          NULL AS ${_expenseLocalDataSource.tableName}_${Model.idColumnName},
          NULL AS ${_expenseLocalDataSource.tableName}_${Model.createdAtColumnName},
          NULL AS ${_expenseLocalDataSource.tableName}_${Model.deletedAtColumnName},
          NULL AS ${_expenseLocalDataSource.tableName}_description,
          NULL AS ${_expenseLocalDataSource.tableName}_id_category,
          NULL AS ${_expenseLocalDataSource.tableName}_id_credit_card_transaction,
          NULL AS ${_expenseLocalDataSource.tableName}_id_transaction,
          NULL AS ${_expenseLocalDataSource.tableName}_observation,
        
          -- Income
          ${_incomeLocalDataSource.tableName}.${Model.idColumnName} AS ${_incomeLocalDataSource.tableName}_${Model.idColumnName},
          ${_incomeLocalDataSource.tableName}.${Model.createdAtColumnName} AS ${_incomeLocalDataSource.tableName}_${Model.createdAtColumnName},
          ${_incomeLocalDataSource.tableName}.${Model.deletedAtColumnName} AS ${_incomeLocalDataSource.tableName}_${Model.deletedAtColumnName},
          ${_incomeLocalDataSource.tableName}.description AS ${_incomeLocalDataSource.tableName}_description,
          ${_incomeLocalDataSource.tableName}.id_category AS ${_incomeLocalDataSource.tableName}_id_category,
          NULL AS ${_expenseLocalDataSource.tableName}_id_credit_card_transaction,
          ${_incomeLocalDataSource.tableName}.id_transaction AS ${_incomeLocalDataSource.tableName}_id_transaction,
          ${_incomeLocalDataSource.tableName}.observation AS ${_incomeLocalDataSource.tableName}_observation,
          
          -- Transaction
          $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
          $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
          $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
          $tableName.amount AS ${tableName}_amount,
          $tableName.type AS ${tableName}_type,
          $tableName.date AS ${tableName}_date,
          $tableName.id_account AS ${tableName}_id_account,
          
          -- Transfers
          NULL AS ${_transferLocalDataSource.tableName}_${Model.idColumnName},
          NULL AS ${_transferLocalDataSource.tableName}_${Model.createdAtColumnName},
          NULL AS ${_transferLocalDataSource.tableName}_${Model.deletedAtColumnName},
          NULL AS ${_transferLocalDataSource.tableName}_id_transaction_from,
          NULL AS ${_transferLocalDataSource.tableName}_id_transaction_to,
          
          -- Transaction from
          NULL AS ${tableName}_from_${Model.idColumnName},
          NULL AS ${tableName}_from_${Model.createdAtColumnName},
          NULL AS ${tableName}_from_${Model.deletedAtColumnName},
          NULL AS ${tableName}_from_amount,
          NULL AS ${tableName}_from_type,
          NULL AS ${tableName}_from_date,
          NULL AS ${tableName}_from_id_account,
          
          -- Transaction to
          NULL AS ${tableName}_to_${Model.idColumnName},
          NULL AS ${tableName}_to_${Model.createdAtColumnName},
          NULL AS ${tableName}_to_${Model.deletedAtColumnName},
          NULL AS ${tableName}_to_amount,
          NULL AS ${tableName}_to_type,
          NULL AS ${tableName}_to_date,
          NULL AS ${tableName}_to_id_account
        FROM ${_incomeLocalDataSource.tableName}
        INNER JOIN $tableName
          ON $tableName.${Model.idColumnName} = ${_incomeLocalDataSource.tableName}.id_transaction
        WHERE
          $tableName.${Model.deletedAtColumnName} IS NULL AND
          $tableName.date BETWEEN ? AND ?
          
        UNION ALL
        
        SELECT
          -- Expense
          NULL AS ${_expenseLocalDataSource.tableName}_${Model.idColumnName},
          NULL AS ${_expenseLocalDataSource.tableName}_${Model.createdAtColumnName},
          NULL AS ${_expenseLocalDataSource.tableName}_${Model.deletedAtColumnName},
          NULL AS ${_expenseLocalDataSource.tableName}_description,
          NULL AS ${_expenseLocalDataSource.tableName}_id_category,
          NULL AS ${_expenseLocalDataSource.tableName}_id_credit_card_transaction,
          NULL AS ${_expenseLocalDataSource.tableName}_id_transaction,
          NULL AS ${_expenseLocalDataSource.tableName}_observation,
          
          -- Income
          NULL AS ${_incomeLocalDataSource.tableName}_${Model.idColumnName},
          NULL AS ${_incomeLocalDataSource.tableName}_${Model.createdAtColumnName},
          NULL AS ${_incomeLocalDataSource.tableName}_${Model.deletedAtColumnName},
          NULL AS ${_incomeLocalDataSource.tableName}_description,
          NULL AS ${_incomeLocalDataSource.tableName}_id_category,
          NULL AS ${_incomeLocalDataSource.tableName}_id_credit_card_transaction,
          NULL AS ${_incomeLocalDataSource.tableName}_id_transaction,
          NULL AS ${_incomeLocalDataSource.tableName}_observation,
        
          -- Transaction
          NULL AS ${tableName}_${Model.idColumnName},
          NULL AS ${tableName}_${Model.createdAtColumnName},
          NULL AS ${tableName}_${Model.deletedAtColumnName},
          NULL AS ${tableName}_amount,
          NULL AS ${tableName}_type,
          ${tableName}_from.date AS ${tableName}_date,
          NULL AS ${tableName}_id_account,
        
          -- Transfers
          ${_transferLocalDataSource.tableName}.${Model.idColumnName} AS ${_transferLocalDataSource.tableName}_${Model.idColumnName},
          ${_transferLocalDataSource.tableName}.${Model.createdAtColumnName} AS ${_transferLocalDataSource.tableName}_${Model.createdAtColumnName},
          ${_transferLocalDataSource.tableName}.${Model.deletedAtColumnName} AS ${_transferLocalDataSource.tableName}_${Model.deletedAtColumnName},
          ${_transferLocalDataSource.tableName}.id_transaction_from AS ${_transferLocalDataSource.tableName}_id_transaction_from,
          ${_transferLocalDataSource.tableName}.id_transaction_to AS ${_transferLocalDataSource.tableName}_id_transaction_to,
          
          -- Transaction from
          ${tableName}_from.${Model.idColumnName} AS ${tableName}_from_${Model.idColumnName},
          ${tableName}_from.${Model.createdAtColumnName} AS ${tableName}_from_${Model.createdAtColumnName},
          ${tableName}_from.${Model.deletedAtColumnName} AS ${tableName}_from_${Model.deletedAtColumnName},
          ${tableName}_from.amount AS ${tableName}_from_amount,
          ${tableName}_from.type AS ${tableName}_from_type,
          ${tableName}_from.date AS ${tableName}_from_date,
          ${tableName}_from.id_account AS ${tableName}_from_id_account,
          
          -- Transaction to
          ${tableName}_to.${Model.idColumnName} AS ${tableName}_to_${Model.idColumnName},
          ${tableName}_to.${Model.createdAtColumnName} AS ${tableName}_to_${Model.createdAtColumnName},
          ${tableName}_to.${Model.deletedAtColumnName} AS ${tableName}_to_${Model.deletedAtColumnName},
          ${tableName}_to.amount AS ${tableName}_to_amount,
          ${tableName}_to.type AS ${tableName}_to_type,
          ${tableName}_to.date AS ${tableName}_to_date,
          ${tableName}_to.id_account AS ${tableName}_to_id_account
        FROM ${_transferLocalDataSource.tableName}
        INNER JOIN $tableName ${tableName}_from
          ON ${tableName}_from.${Model.idColumnName} = ${_transferLocalDataSource.tableName}.id_transaction_from
        INNER JOIN $tableName ${tableName}_to
          ON ${tableName}_to.${Model.idColumnName} = ${_transferLocalDataSource.tableName}.id_transaction_to
        WHERE
          ${tableName}_from.${Model.deletedAtColumnName} IS NULL AND
          ${tableName}_from.date BETWEEN ? AND ?
      )
      ORDER BY ${tableName}_date DESC;
    ''';

    final List<Map<String, dynamic>> results = await databaseLocal.raw(
      sql,
      DatabaseOperation.select,
      [startDate.toIso8601String(), endDate.toIso8601String(), startDate.toIso8601String(), endDate.toIso8601String(), startDate.toIso8601String(), endDate.toIso8601String()],
    );

    final List<ITransactionModel> listModels = [];

    for (final result in results) {
      if (result['${_expenseLocalDataSource.tableName}_${Model.idColumnName}'] != null) {
        listModels.add(_expenseLocalDataSource.fromMap(result, prefix: '${_expenseLocalDataSource.tableName}_'));
      }

      if (result['${_incomeLocalDataSource.tableName}_${Model.idColumnName}'] != null) {
        listModels.add(_incomeLocalDataSource.fromMap(result, prefix: '${_incomeLocalDataSource.tableName}_'));
      }

      if (result['${_transferLocalDataSource.tableName}_${Model.idColumnName}'] != null) {
        listModels.add(_transferLocalDataSource.fromMap(result, prefix: '${_transferLocalDataSource.tableName}_'));
      }
    }

    return listModels;
  }

  @override
  Future<List<ITransactionModel>> findIncomeByText(String text) async {
    final String sql = '''
      SELECT
        -- Income
        ${_incomeLocalDataSource.tableName}.${Model.idColumnName} AS ${_incomeLocalDataSource.tableName}_${Model.idColumnName},
        ${_incomeLocalDataSource.tableName}.${Model.createdAtColumnName} AS ${_incomeLocalDataSource.tableName}_${Model.createdAtColumnName},
        ${_incomeLocalDataSource.tableName}.${Model.deletedAtColumnName} AS ${_incomeLocalDataSource.tableName}_${Model.deletedAtColumnName},
        ${_incomeLocalDataSource.tableName}.description AS ${_incomeLocalDataSource.tableName}_description,
        ${_incomeLocalDataSource.tableName}.id_category AS ${_incomeLocalDataSource.tableName}_id_category,
        ${_incomeLocalDataSource.tableName}.id_transaction AS ${_incomeLocalDataSource.tableName}_id_transaction,
        ${_incomeLocalDataSource.tableName}.observation AS ${_incomeLocalDataSource.tableName}_observation,
        
        -- Transaction
        $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
        $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
        $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
        $tableName.amount AS ${tableName}_amount,
        $tableName.type AS ${tableName}_type,
        $tableName.date AS ${tableName}_date,
        $tableName.id_account AS ${tableName}_id_account
      FROM ${_incomeLocalDataSource.tableName}
      INNER JOIN $tableName
        ON $tableName.${Model.idColumnName} = ${_incomeLocalDataSource.tableName}.id_transaction
      WHERE
        $tableName.${Model.deletedAtColumnName} IS NULL AND
        ${_incomeLocalDataSource.tableName}.description LIKE ?
      GROUP BY lower(${_incomeLocalDataSource.tableName}.description)
      ORDER BY $orderByDefault
      LIMIT 10;
    ''';

    final List<Map<String, dynamic>> results = await databaseLocal.raw(sql, DatabaseOperation.select, ['%$text%']);

    return results.map((result) => _incomeLocalDataSource.fromMap(result, prefix: '${_incomeLocalDataSource.tableName}_')).toList();
  }

  @override
  Future<List<ITransactionModel>> findExpenseByText(String text) async {
    final String sql = '''
      SELECT
        -- Expense
        ${_expenseLocalDataSource.tableName}.${Model.idColumnName} AS ${_expenseLocalDataSource.tableName}_${Model.idColumnName},
        ${_expenseLocalDataSource.tableName}.${Model.createdAtColumnName} AS ${_expenseLocalDataSource.tableName}_${Model.createdAtColumnName},
        ${_expenseLocalDataSource.tableName}.${Model.deletedAtColumnName} AS ${_expenseLocalDataSource.tableName}_${Model.deletedAtColumnName},
        ${_expenseLocalDataSource.tableName}.description AS ${_expenseLocalDataSource.tableName}_description,
        ${_expenseLocalDataSource.tableName}.id_category AS ${_expenseLocalDataSource.tableName}_id_category,
        ${_expenseLocalDataSource.tableName}.id_credit_card_transaction AS ${_expenseLocalDataSource.tableName}_id_credit_card_transaction,
        ${_expenseLocalDataSource.tableName}.id_transaction AS ${_expenseLocalDataSource.tableName}_id_transaction,
        ${_expenseLocalDataSource.tableName}.observation AS ${_expenseLocalDataSource.tableName}_observation,
        
        -- Transaction
        $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
        $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
        $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
        $tableName.amount AS ${tableName}_amount,
        $tableName.type AS ${tableName}_type,
        $tableName.date AS ${tableName}_date,
        $tableName.id_account AS ${tableName}_id_account
      FROM ${_expenseLocalDataSource.tableName}
      INNER JOIN $tableName
        ON $tableName.${Model.idColumnName} = ${_expenseLocalDataSource.tableName}.id_transaction
      WHERE
        $tableName.${Model.deletedAtColumnName} IS NULL AND
        ${_expenseLocalDataSource.tableName}.description LIKE ?
      GROUP BY lower(${_expenseLocalDataSource.tableName}.description)
      ORDER BY $orderByDefault
      LIMIT 10;
    ''';

    final List<Map<String, dynamic>> results = await databaseLocal.raw(sql, DatabaseOperation.select, ['%$text%']);

    return results.map((result) => _expenseLocalDataSource.fromMap(result, prefix: '${_expenseLocalDataSource.tableName}_')).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> findMonthlyBalances({required DateTime startDate, required DateTime endDate}) async {
    try {
      startDate = startDate.getInitialMonth();
      endDate = endDate.getFinalMonth();

      const String sql = '''
        SELECT
          STRFTIME('%Y-%m-01', date) AS month,
          ROUND(SUM(amount), 2) AS monthly_sum
        FROM transactions
        WHERE
          date BETWEEN ? AND ? AND
          ${Model.deletedAtColumnName} IS NULL
        GROUP BY month;
    ''';

      return await databaseLocal.raw(sql, DatabaseOperation.select, [startDate.toIso8601String(), endDate.toIso8601String()]);
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }
}
