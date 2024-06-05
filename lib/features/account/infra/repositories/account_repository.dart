import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class AccountRepository implements IAccountRepository {
  final IAccountLocalDataSource _dataSource;
  final ICreditCardLocalDataSource _creditCardLocalDataSource;

  AccountRepository({
    required IAccountLocalDataSource dataSource,
    required ICreditCardLocalDataSource creditCardLocalDataSource,
  })  : _dataSource = dataSource,
        _creditCardLocalDataSource = creditCardLocalDataSource;

  @override
  Future<List<AccountEntity>> findAll({bool deleted = false}) async {
    final List<AccountModel> accounts = await _dataSource.findAll(deleted: deleted);
    return accounts.map((account) => AccountFactory.toEntity(account)).toList();
  }

  @override
  Future<AccountEntity?> findById(String id) async {
    final AccountModel? account = await _dataSource.findById(id);
    return account != null ? AccountFactory.toEntity(account) : null;
  }

  @override
  Future<AccountEntity> save(AccountEntity entity) async {
    final AccountModel account = await _dataSource.upsert(AccountFactory.fromEntity(entity));
    return AccountFactory.toEntity(account);
  }

  @override
  Future<void> delete(AccountEntity entity) async {
    final bool existsCreditCard = await _creditCardLocalDataSource.exists(where: 'id_account = ? AND ${Model.deletedAtColumnName} IS NULL', whereArgs: [entity.id]);
    if (existsCreditCard) throw Exception(R.strings.accountUsedCreditCard);

    await _dataSource.delete(AccountFactory.fromEntity(entity));
  }

  @override
  Future<double> findBalanceUntilDate(DateTime date) => _dataSource.findBalanceUntilDate(date);
}
