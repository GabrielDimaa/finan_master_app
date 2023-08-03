import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

class AccountRepository implements IAccountRepository {
  final IAccountDataSource _accountDataSource;

  AccountRepository({required IAccountDataSource accountDataSource}) : _accountDataSource = accountDataSource;

  @override
  Future<Result<List<AccountEntity>, BaseException>> findAll() async {
    final List<AccountModel> accounts = await _accountDataSource.findAll();
    return Result.success(accounts.map((account) => AccountFactory.toEntity(account)).toList());
  }
}
