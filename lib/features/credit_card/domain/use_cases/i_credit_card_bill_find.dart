import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';

abstract interface class ICreditCardBillFind {
  Future<CreditCardBillEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard});

  Future<List<CreditCardBillEntity>> findAllAfterDate({required DateTime date, required String idCreditCard});

  Future<CreditCardBillEntity?> findById(String id);
}
