import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransactionLocalDataSource extends LocalDataSource<TransactionModel> implements ITransactionLocalDataSource {
  TransactionLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => 'transactions';

  @override
  String get orderByDefault => '${tableName}_date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        amount REAL NOT NULL,
        type REAL NOT NULL,
        date TEXT NOT NULL,
        id_account TEXT NOT NULL REFERENCES accounts(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT
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
      date: map['${prefix}date'],
      idAccount: map['${prefix}id_account'],
    );
  }

  @override
  Future<List<TransactionModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, ITransactionExecutor? txn}) async {
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
  }
}
