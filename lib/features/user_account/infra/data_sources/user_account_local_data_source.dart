import 'package:finan_master_app/features/user_account/infra/data_sources/i_user_account_local_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/models/user_account_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';

class UserAccountLocalDataSource extends LocalDataSource<UserAccountModel> implements IUserAccountLocalDataSource {
  UserAccountLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => userAccountTableName;

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        email TEXT NOT NULL,
        name TEXT NOT NULL
      );
    ''');
  }

  @override
  UserAccountModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return UserAccountModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      email: map['${prefix}email'],
      name: map['${prefix}name'],
    );
  }

  @override
  Future<void> deleteAll() => databaseLocal.delete(tableName);
}
