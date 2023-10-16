import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardLocalDataSource extends LocalDataSource<CreditCardModel> implements ICreditCardLocalDataSource {
  CreditCardLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => 'credit_cards';

  @override
  String get orderByDefault => 'description COLLATE NOCASE';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        amount_limit REAL NOT NULL,
        statement_closing_day INTEGER NOT NULL,
        statement_due_day INTEGER NOT NULL,
        brand INTEGER NOT NULL,
        id_account TEXT NOT NULL REFERENCES accounts(${Model.idColumnName}) ON UPDATE CASCADE ON DELETE RESTRICT
      );
    ''');
  }

  @override
  CreditCardModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return CreditCardModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      amountLimit: map['${prefix}amount_limit'],
      statementClosingDay: map['${prefix}statement_closing_day'],
      statementDueDay: map['${prefix}statement_due_day'],
      brand: CardBrandEnum.getByValue(map['${prefix}brand'])!,
      idAccount: map['${prefix}id_account'],
    );
  }
}
