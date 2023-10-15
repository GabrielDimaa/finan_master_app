import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';

abstract interface class ICreditCardRepository {
  Future<CreditCardEntity> save(CreditCardEntity entity);

  Future<void> delete(CreditCardEntity entity);

  Future<List<CreditCardEntity>> findAll();

  Future<CreditCardEntity?> findById(String id);

  Future<CreditCardTransactionEntity> saveTransaction(CreditCardTransactionEntity entity);

  Future<CreditCardTransactionEntity> saveTransactionWithNewStatement({required CreditCardTransactionEntity entity, required CreditCardStatementEntity statement});

  Future<CreditCardStatementEntity?> findStatementById(String id);

  Future<CreditCardStatementEntity?> findStatementByDate({required DateTime date, required String idCreditCard});
}
