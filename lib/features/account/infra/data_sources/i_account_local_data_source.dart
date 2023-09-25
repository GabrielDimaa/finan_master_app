import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class IAccountLocalDataSource implements ILocalDataSource<AccountModel> {
  Future<double> findBalanceUntilDate(DateTime date);
}
