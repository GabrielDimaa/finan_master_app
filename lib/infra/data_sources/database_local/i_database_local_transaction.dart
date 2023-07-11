import 'package:finan_master_app/infra/data_sources/database_local/i_database_local.dart';

typedef ActionTxn<T> = Future<T> Function(ITransactionExecutor txn);

abstract interface class IDatabaseLocalTransaction {
  Future<T> openTransaction<T>(ActionTxn<T> action);
}

abstract interface class ITransactionExecutor implements IDatabaseLocal {}
