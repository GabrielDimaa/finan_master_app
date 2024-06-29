import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/features/account/infra/models/account_simple.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class IAccountLocalDataSource implements ILocalDataSource<AccountModel> {
  Future<double> findBalanceUntilDate(DateTime date);

  Future<List<AccountSimpleModel>> getAllSimplesByIds(List<String> ids, {ITransactionExecutor? txn});

  Future<AccountSimpleModel?> getSimpleById(String id, {ITransactionExecutor? txn});
}
