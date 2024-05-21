import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/features/auth/infra/data_sources/i_auth_local_data_source.dart';
import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';

class AuthLocalDataSource extends LocalDataSource<AuthModel> implements IAuthLocalDataSource {
  AuthLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => authTableName;

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        email TEXT NOT NULL,
        email_verified INTEGER NOT NULL,
        password TEXT,
        type INTEGER NOT NULL
      );
    ''');
  }

  @override
  AuthModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return AuthModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      email: map['${prefix}email'],
      emailVerified: map['${prefix}email_verified'] == 1,
      password: map['${prefix}password'],
      type: AuthType.getByValue(map['${prefix}type']),
    );
  }

  @override
  Future<void> deleteAll() => databaseLocal.delete(tableName);

  @override
  Future<void> saveEmailVerified(bool isEmailVerified) => databaseLocal.update(tableName, {'email_verified': isEmailVerified ? 1 : 0});
}
