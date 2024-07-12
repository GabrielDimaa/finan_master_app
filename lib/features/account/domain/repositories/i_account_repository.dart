import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';

abstract interface class IAccountRepository {
  Future<List<AccountEntity>> findAll({bool deleted = false});

  Future<AccountEntity?> findById(String id);

  Future<AccountEntity> save(AccountEntity entity);

  Future<void> delete(AccountEntity entity);

  Future<double> findBalanceUntilDate(DateTime date);

  Future<double> findAccountsBalance();
}
