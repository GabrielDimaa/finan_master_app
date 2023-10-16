import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class ICreditCardRepository {
  Future<CreditCardEntity> save(CreditCardEntity entity, {ITransactionExecutor? txn});

  Future<void> delete(CreditCardEntity entity);

  Future<List<CreditCardEntity>> findAll();

  Future<CreditCardEntity?> findById(String id, {ITransactionExecutor? txn});
}
