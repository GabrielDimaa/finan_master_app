import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/features/account/infra/models/account_simple.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';
import 'package:uuid/uuid.dart';

class AccountLocalDataSource extends LocalDataSource<AccountModel> implements IAccountLocalDataSource {
  AccountLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => accountsTableName;

  @override
  String get orderByDefault => 'description COLLATE NOCASE';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        initial_amount REAL NOT NULL DEFAULT 0,
        financial_institution INTEGER NOT NULL,
        include_total_balance INTEGER NOT NULL DEFAULT 1
      );
    ''');

    batch.execute('''
      INSERT INTO $tableName (${Model.idColumnName}, ${Model.createdAtColumnName}, description, initial_amount, financial_institution, include_total_balance)
      VALUES ('${const Uuid().v1()}', '${DateTime.now().toIso8601String()}', '${FinancialInstitutionEnum.wallet.description}', 0, ${FinancialInstitutionEnum.wallet.value}, 1);
    ''');
  }

  @override
  AccountModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return AccountModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      transactionsAmount: map['${prefix}transactions_amount'],
      initialAmount: map['${prefix}initial_amount'],
      financialInstitution: FinancialInstitutionEnum.getByValue(map['${prefix}financial_institution'])!,
      includeTotalBalance: map['${prefix}include_total_balance'] == 1,
    );
  }

  @override
  Future<List<AccountModel>> selectFull({String? id, bool deleted = false, String? where, List? whereArgs, String? orderBy, int? offset, int? limit, String? groupBy, ITransactionExecutor? txn}) async {
    try {
      List<String> whereListed = [];
      whereArgs ??= [];

      if (where?.isNotEmpty == true) {
        whereListed.add(where!);
      }

      if (id != null) {
        whereListed.add('$tableName.${Model.idColumnName} = ?');
        whereArgs.add(id);
      }

      if (!deleted) {
        whereListed.add('$tableName.${Model.deletedAtColumnName} IS NULL');
      }

      whereListed.add('$statementsTableName.${Model.deletedAtColumnName} IS NULL');

      final String sql = '''
        SELECT
          $tableName.*,
          COALESCE(SUM($statementsTableName.amount), 0.0) as transactions_amount
        FROM $tableName
        LEFT JOIN $statementsTableName
          ON $tableName.id = $statementsTableName.id_account AND $statementsTableName.${Model.deletedAtColumnName} IS NULL
        ${whereListed.isNotEmpty ? 'WHERE ${whereListed.join(' AND ')}' : ''}
        GROUP BY ${groupBy?.isNotEmpty == true ? '$groupBy' : '$tableName.${Model.idColumnName}, description'}
        ORDER BY ${orderBy ?? orderByDefault}
        ${limit != null ? ' LIMIT $limit' : ''}
        ${offset != null ? ' OFFSET $offset' : ''};
      ''';

      final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).raw(sql, DatabaseOperation.select, whereArgs);

      return results.map((e) => fromMap(e)).toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<double> findBalanceUntilDate(DateTime date) async {
    try {
      const String sql = '''
        SELECT
          SUM(amount) + (SELECT SUM(initial_amount) FROM accounts WHERE accounts.${Model.deletedAtColumnName} IS NULL) AS balance
        FROM $statementsTableName
        WHERE date <= ? AND ${Model.deletedAtColumnName} IS NULL;
      ''';

      final List<Map<String, dynamic>> results = await databaseLocal.raw(sql, DatabaseOperation.select, [date.toIso8601String()]);

      return results.firstOrNull?['balance'] ?? 0;
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<List<AccountSimpleModel>> getAllSimplesByIds(List<String> ids, {ITransactionExecutor? txn}) async {
    try {
      final List<Map<String, dynamic>> results = await (txn ?? databaseLocal).query(tableName, where: '${Model.idColumnName} IN (${ids.map((e) => '?').join(', ')})', whereArgs: ids);

      return results.map((e) => AccountSimpleModel(id: e['id'], description: e['description'], financialInstitution: FinancialInstitutionEnum.getByValue(e['financial_institution'])!)).toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }

  @override
  Future<AccountSimpleModel?> getSimpleById(String id, {ITransactionExecutor? txn}) async => (await getAllSimplesByIds([id], txn: txn)).firstOrNull;
}
