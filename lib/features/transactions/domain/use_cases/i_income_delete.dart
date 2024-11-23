import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class IIncomeDelete {
  Future<void> delete(IncomeEntity entity, {ITransactionExecutor? txn});
}
