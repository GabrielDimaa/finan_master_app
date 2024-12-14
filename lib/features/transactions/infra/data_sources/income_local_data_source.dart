import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_by_text_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local_exception.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_operation.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class IncomeLocalDataSource extends LocalDataSource<IncomeModel> implements IIncomeLocalDataSource {
  IncomeLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => incomesTableName;

  @override
  String get orderByDefault => 'date DESC';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        paid INTEGER NOT NULL DEFAULT 1,
        id_account TEXT NOT NULL REFERENCES $accountsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_category TEXT NOT NULL REFERENCES $categoriesTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
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
      amount: map['${prefix}amount'],
      date: DateTime.tryParse(map['${prefix}date'].toString())!.toLocal(),
      paid: map['${prefix}paid'] == 1,
      observation: map['${prefix}observation'],
      idAccount: map['${prefix}id_account'],
      idCategory: map['${prefix}id_category'],
    );
  }

  @override
  Future<List<TransactionByTextModel>> findByText(String text) async {
    try {
      final String sql = '''
        SELECT
          description,
          id_category,
          id_account,
          observation
        FROM
          $tableName
        WHERE
          LOWER(description) LIKE LOWER(?)
        GROUP BY description, id_category
        ORDER BY
          CASE
            WHEN LOWER(description) LIKE LOWER(?) THEN 1
            WHEN LOWER(description) LIKE LOWER(?) THEN 2
            ELSE 3
          END,
          MAX(${Model.createdAtColumnName}) DESC,
          description
        LIMIT 20;
      ''';

      final List<Map<String, dynamic>> results = await databaseLocal.raw(sql, DatabaseOperation.select, ['%$text%', '%$text%', text, '$text%']);

      return results
          .map((e) => TransactionByTextModel(
                description: e['description'],
                idCategory: e['id_category'],
                idAccount: e['id_account'],
                idCreditCard: null,
                observation: e['observation'],
              ))
          .toList();
    } on DatabaseLocalException catch (e, stackTrace) {
      throw throwable(e, stackTrace);
    }
  }
}
