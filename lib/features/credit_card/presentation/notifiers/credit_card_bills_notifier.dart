import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_find.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_bills_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardBillsNotifier extends ValueNotifier<CreditCardBillsState> {
  final ICreditCardBillFind _creditCardBillFind;

  CreditCardBillsNotifier({required ICreditCardBillFind creditCardBillFind})
      : _creditCardBillFind = creditCardBillFind,
        super(CreditCardBillsState.start());

  void setBills(List<CreditCardBillEntity> bills) => value = value.setBills(bills);

  Future<void> findAllAfterDate({required DateTime date, required String idCreditCard}) async {
    try {
      value = value.setLoading();
      final List<CreditCardBillEntity> bills = await _creditCardBillFind.findAllAfterDate(date: date, idCreditCard: idCreditCard);

      value = value.setBills(bills);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
