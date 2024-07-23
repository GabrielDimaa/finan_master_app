import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';

class CreditCardWithBillEntity {
  final CreditCardEntity creditCard;
  final CreditCardBillEntity? bill;

  CreditCardWithBillEntity({required this.creditCard, required this.bill});
}
