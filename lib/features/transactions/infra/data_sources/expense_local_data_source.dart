import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class ExpenseLocalDataSource extends LocalDataSource<ExpenseModel> implements IExpenseLocalDataSource {
  ExpenseLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => expensesTableName;

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
        id_credit_card_transaction TEXT REFERENCES $creditCardTransactionsTableName(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        observation TEXT
      );
    ''');
  }

  @override
  ExpenseModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return ExpenseModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      amount: map['${prefix}amount'],
      date: DateTime.tryParse(map['${prefix}date'].toString())!.toLocal(),
      paid: map['${prefix}paid'],
      observation: map['${prefix}observation'],
      idAccount: map['${prefix}id_account'],
      idCategory: map['${prefix}id_category'],
      idCreditCardTransaction: map['${prefix}id_credit_card_transaction'],
    );
  }

  @override
  Future<List<ExpenseModel>> findByText(String text) async {
    return await selectFull(
      where: 'description LIKE ?',
      whereArgs: ['%$text%'],
      groupBy: 'LOWER(description)',
      limit: 15,
    );
  }
}
