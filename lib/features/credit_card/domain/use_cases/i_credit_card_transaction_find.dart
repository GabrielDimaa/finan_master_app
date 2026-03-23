import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';

abstract interface class ICreditCardTransactionFind {
  Future<CreditCardTransactionEntity?> findById(String id);
}