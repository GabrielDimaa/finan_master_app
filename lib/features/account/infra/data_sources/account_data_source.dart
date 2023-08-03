import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';

class AccountDataSource extends LocalDataSource<AccountModel> implements IAccountDataSource {
  AccountDataSource({required super.databaseLocal});

  @override
  String get tableName => 'accounts';

  @override
  String get orderByDefault => 'description COLLATE NOCASE';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        initial_value REAL NOT NULL DEFAULT 0,
        financial_institution INTEGER NOT NULL,
        include_total_balance INTEGER NOT NULL DEFAULT 1
      );
    ''');
  }

  @override
  AccountModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return AccountModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['description'],
      initialValue: map['initial_value'],
      financialInstitution: FinancialInstitutionEnum.getByValue(map['financial_institution'])!,
      includeTotalBalance: map['include_total_balance'],
    );
  }
}
