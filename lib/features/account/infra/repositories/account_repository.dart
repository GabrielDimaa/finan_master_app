import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

class AccountRepository implements IAccountRepository {
  final IAccountDataSource _dataSource;

  AccountRepository({required IAccountDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<Result<List<AccountEntity>, BaseException>> findAll() async {
    final List<AccountModel> accounts = await _dataSource.findAll();
    return Result.success(accounts.map((account) => AccountFactory.toEntity(account)).toList());
  }

  @override
  Future<Result<AccountEntity, BaseException>> save(AccountEntity entity) async {
    final AccountModel account = await _dataSource.upsert(AccountFactory.fromEntity(entity));

    return Result.success(AccountFactory.toEntity(account));
  }

  @override
  Future<Result<dynamic, BaseException>> delete(AccountEntity entity) async {
    await _dataSource.delete(AccountFactory.fromEntity(entity));

    return Result.success(null);
  }
}
