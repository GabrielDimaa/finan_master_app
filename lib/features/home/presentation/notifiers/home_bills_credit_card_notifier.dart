import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_with_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/features/home/presentation/states/home_bills_credit_card_state.dart';
import 'package:flutter/foundation.dart';

class HomeBillsCreditCardNotifier extends ValueNotifier<HomeBillsCreditCardState> {
  final ICreditCardFind _creditCardFind;

  HomeBillsCreditCardNotifier({required ICreditCardFind creditCardFind})
      : _creditCardFind = creditCardFind,
        super(HomeBillsCreditCardState.start());

  List<CreditCardWithBillEntity> get creditCardsWithBill => value.creditCardsWithBill;

  Future<void> load() async {
    try {
      value = value.setLoading();

      final List<CreditCardWithBillEntity> creditCardsWithBill = await _creditCardFind.findCreditCardsWithBill();

      value = value.setCreditCardsWithBill(creditCardsWithBill);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
