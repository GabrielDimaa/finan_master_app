import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';

class AccountRepository implements IAccountRepository {
  final IAccountDataSource _dataSource;

  AccountRepository({required IAccountDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<List<AccountEntity>> findAll() async {
    final List<AccountModel> accounts = await _dataSource.findAll();
    return accounts.map((account) => AccountFactory.toEntity(account)).toList();
  }

  @override
  Future<AccountEntity> save(AccountEntity entity) async {
    final AccountModel account = await _dataSource.upsert(AccountFactory.fromEntity(entity));
    return AccountFactory.toEntity(account);
  }

  @override
  Future<void> delete(AccountEntity entity) => _dataSource.delete(AccountFactory.fromEntity(entity));
}
