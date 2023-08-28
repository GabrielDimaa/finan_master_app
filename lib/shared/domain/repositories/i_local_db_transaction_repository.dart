import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class ILocalDBTransactionRepository {
  Future<T> openTransaction<T>(ActionTxn<T> action);
}
