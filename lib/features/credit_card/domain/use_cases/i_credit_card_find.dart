import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_with_bill_entity.dart';

abstract interface class ICreditCardFind {
  Future<List<CreditCardEntity>> findAll();

  Future<CreditCardEntity?> findById(String id);

  Future<List<CreditCardWithBillEntity>> findCreditCardsWithBill();
}
