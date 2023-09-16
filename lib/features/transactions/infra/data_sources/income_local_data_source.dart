import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class IncomeLocalDataSource extends LocalDataSource<IncomeModel> implements IIncomeLocalDataSource {
  final ITransactionLocalDataSource _transactionDataSource;

  IncomeLocalDataSource({required super.databaseLocal, required ITransactionLocalDataSource transactionDataSource}) : _transactionDataSource = transactionDataSource;

  @override
  String get tableName => incomesTableName;

  @override
  String get orderByDefault => '${_transactionDataSource.tableName}_date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        id_category TEXT NOT NULL REFERENCES categories(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_transaction TEXT NOT NULL REFERENCES ${_transactionDataSource.tableName}(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE CASCADE,
        observation TEXT
      );
    ''');
  }

  @override
  IncomeModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return IncomeModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      observation: map['${prefix}observation'],
      idCategory: map['${prefix}id_category'],
      transaction: _transactionDataSource.fromMap(map, prefix: '${_transactionDataSource.tableName}_'),
    );
  }

  @override
  Future<List<IncomeModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, ITransactionExecutor? txn}) async {
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
          -- Income
          $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
          $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
          $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
          $tableName.description AS ${tableName}_description,
          $tableName.id_category AS ${tableName}_id_category,
          $tableName.id_transaction AS ${tableName}_id_transaction,
          $tableName.observation AS ${tableName}_observation,
          
          -- Transaction
          ${_transactionDataSource.tableName}.${Model.idColumnName} AS ${_transactionDataSource.tableName}_${Model.idColumnName},
          ${_transactionDataSource.tableName}.${Model.createdAtColumnName} AS ${_transactionDataSource.tableName}_${Model.createdAtColumnName},
          ${_transactionDataSource.tableName}.${Model.deletedAtColumnName} AS ${_transactionDataSource.tableName}_${Model.deletedAtColumnName},
          ${_transactionDataSource.tableName}.amount AS ${_transactionDataSource.tableName}_amount,
          ${_transactionDataSource.tableName}.type AS ${_transactionDataSource.tableName}_type,
          ${_transactionDataSource.tableName}.date AS ${_transactionDataSource.tableName}_date,
          ${_transactionDataSource.tableName}.id_account AS ${_transactionDataSource.tableName}_id_account
        FROM $tableName
        INNER JOIN ${_transactionDataSource.tableName}
          ON ${_transactionDataSource.tableName}.${Model.idColumnName} = $tableName.id_transaction
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
  Future<List<IncomeModel>> findByPeriod(DateTime start, DateTime end) => selectFull(where: '${_transactionDataSource.tableName}.date BETWEEN ? AND ?', whereArgs: [start.toIso8601String(), end.toIso8601String()]);
}
