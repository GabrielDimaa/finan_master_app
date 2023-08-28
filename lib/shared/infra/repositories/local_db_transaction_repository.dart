import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class LocalDBTransactionRepository implements ILocalDBTransactionRepository {
  final IDatabaseLocalTransaction _databaseLocalTransaction;

  LocalDBTransactionRepository({required IDatabaseLocalTransaction databaseLocalTransaction}) : _databaseLocalTransaction = databaseLocalTransaction;

  @override
  Future<T> openTransaction<T>(ActionTxn<T> action) => _databaseLocalTransaction.openTransaction(action);
}
