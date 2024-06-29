import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';

abstract interface class ICreditCardBillSave {
  Future<CreditCardBillEntity> payBill({required CreditCardBillEntity creditCardBill, required double payValue});
}
