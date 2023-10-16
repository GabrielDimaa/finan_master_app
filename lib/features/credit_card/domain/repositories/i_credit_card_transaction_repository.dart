import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';

abstract interface class ICreditCardTransactionRepository {
  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity);

  Future<CreditCardTransactionEntity> saveTransactionWithNewStatement({required CreditCardTransactionEntity entity, required CreditCardStatementEntity statement});
}
