import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardTransactionLocalDataSource extends LocalDataSource<CreditCardTransactionModel> implements ICreditCardTransactionLocalDataSource {
  CreditCardTransactionLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => 'credit_card_transactions';

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
        id_category TEXT NOT NULL REFERENCES categories(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_credit_card TEXT NOT NULL REFERENCES credit_cards(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        id_credit_card_statement TEXT REFERENCES credit_card_statements(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT,
        observation TEXT
      );
    ''');
  }

  @override
  CreditCardTransactionModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return CreditCardTransactionModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      amount: map['${prefix}amount'],
      date: DateTime.tryParse(map['${prefix}date'].toString())!.toLocal(),
      idCategory: map['${prefix}id_category'],
      idCreditCard: map['${prefix}id_credit_card'],
      idCreditCardStatement: map['${prefix}id_credit_card_statement'],
      observation: map['${prefix}observation'],
    );
  }
}
