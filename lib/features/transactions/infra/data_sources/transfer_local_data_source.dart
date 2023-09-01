import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransferLocalDataSource extends LocalDataSource<TransferModel> implements ITransferLocalDataSource {
  final ITransactionLocalDataSource _transactionDataSource;

  TransferLocalDataSource({required super.databaseLocal, required ITransactionLocalDataSource transactionDataSource}) : _transactionDataSource = transactionDataSource;

  @override
  String get tableName => 'transfers';

  @override
  String get orderByDefault => '${_transactionDataSource.tableName}_date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        id_transaction_from TEXT NOT NULL REFERENCES ${_transactionDataSource.tableName}(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE UPDATE,
        id_transaction_to TEXT NOT NULL REFERENCES ${_transactionDataSource.tableName}(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE UPDATE
      );
    ''');
  }

  @override
  TransferModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return TransferModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      transactionFrom: _transactionDataSource.fromMap(map, prefix: '${_transactionDataSource.tableName}_from_'),
      transactionTo: _transactionDataSource.fromMap(map, prefix: '${_transactionDataSource.tableName}_to_'),
    );
  }

  @override
  Future<List<TransferModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, ITransactionExecutor? txn}) async {
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
        -- Trnasfers
        $tableName.${Model.idColumnName} AS ${tableName}_${Model.idColumnName},
        $tableName.${Model.createdAtColumnName} AS ${tableName}_${Model.createdAtColumnName},
        $tableName.${Model.deletedAtColumnName} AS ${tableName}_${Model.deletedAtColumnName},
        $tableName.id_transaction_from AS ${tableName}_id_transaction_from,
        $tableName.id_transaction_to AS ${tableName}_id_transaction_to,
        
        -- Transaction from
        ${_transactionDataSource.tableName}_from.${Model.idColumnName} AS ${_transactionDataSource.tableName}_from_${Model.idColumnName},
        ${_transactionDataSource.tableName}_from.${Model.createdAtColumnName} AS ${_transactionDataSource.tableName}_from_${Model.createdAtColumnName},
        ${_transactionDataSource.tableName}_from.${Model.deletedAtColumnName} AS ${_transactionDataSource.tableName}_from_${Model.deletedAtColumnName},
        ${_transactionDataSource.tableName}_from.amount AS ${_transactionDataSource.tableName}_from_amount,
        ${_transactionDataSource.tableName}_from.type AS ${_transactionDataSource.tableName}_from_type,
        ${_transactionDataSource.tableName}_from.date AS ${_transactionDataSource.tableName}_from_date,
        ${_transactionDataSource.tableName}_from.id_account AS ${_transactionDataSource.tableName}_from_id_account,
        
        -- Transaction to
        ${_transactionDataSource.tableName}_to.${Model.idColumnName} AS ${_transactionDataSource.tableName}_to_${Model.idColumnName},
        ${_transactionDataSource.tableName}_to.${Model.createdAtColumnName} AS ${_transactionDataSource.tableName}_to_${Model.createdAtColumnName},
        ${_transactionDataSource.tableName}_to.${Model.deletedAtColumnName} AS ${_transactionDataSource.tableName}_to_${Model.deletedAtColumnName},
        ${_transactionDataSource.tableName}_to.amount AS ${_transactionDataSource.tableName}_to_amount,
        ${_transactionDataSource.tableName}_to.type AS ${_transactionDataSource.tableName}_to_type,
        ${_transactionDataSource.tableName}_to.date AS ${_transactionDataSource.tableName}_to_date,
        ${_transactionDataSource.tableName}_to.id_account AS ${_transactionDataSource.tableName}_to_id_account
      FROM $tableName
      INNER JOIN ${_transactionDataSource.tableName} ${_transactionDataSource.tableName}_from
        ON ${_transactionDataSource.tableName}.${Model.idColumnName} = $tableName.id_transaction_from
      INNER JOIN ${_transactionDataSource.tableName} ${_transactionDataSource.tableName}_to
        ON ${_transactionDataSource.tableName}.${Model.idColumnName} = $tableName.id_transaction_to
      ${whereListed.isNotEmpty ? 'WHERE ${whereListed.join(' AND ')}' : ''}
      ORDER BY ${orderBy ?? orderByDefault}
      ${limit != null ? ' LIMIT $limit' : ''}
      ${offset != null ? ' OFFSET $offset' : ''};
    ''';

    final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).raw(sql, DatabaseOperation.select, whereArgs);

    return results.map((e) => fromMap(e, prefix: '${tableName}_')).toList();
  }
}
