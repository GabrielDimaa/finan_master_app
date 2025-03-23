import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class ICreditCardTransactionRepository {
  Future<CreditCardTransactionEntity?> findById(String id, {ITransactionExecutor? txn});

  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity, {ITransactionExecutor? txn});

  Future<void> saveMany(List<CreditCardTransactionEntity> transactions, {ITransactionExecutor? txn});

  Future<void> delete(CreditCardTransactionEntity entity, {ITransactionExecutor? txn});

  Future<void> deleteMany(List<CreditCardTransactionEntity> entities, {ITransactionExecutor? txn});
}
