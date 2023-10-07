import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_cards_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardsNotifier extends ValueNotifier<CreditCardsState> {
  final ICreditCardFind _creditCardFind;

  CreditCardsNotifier({required ICreditCardFind creditCardFind})
      : _creditCardFind = creditCardFind,
        super(CreditCardsState.start());

  Future<void> findAll({bool deleted = false}) async {
    try {
      value = value.setLoading();

      final List<CreditCardEntity> creditCards = await _creditCardFind.findAll();
      value = value.setCreditCards(creditCards);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
