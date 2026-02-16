import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class IAccountRepository {
  Future<List<AccountEntity>> findAll({bool deleted = false});

  Future<AccountEntity?> findById(String id);

  Future<AccountEntity> save(AccountEntity entity, {ITransactionExecutor? txn});

  Future<void> delete(AccountEntity entity);

  Future<double> findBalanceUntilDate(DateTime date);

  Future<double> findAccountsBalance();
}
