import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardNotifier extends ValueNotifier<CreditCardState> {
  final ICreditCardSave _creditCardSave;
  final ICreditCardDelete _creditCardDelete;

  CreditCardNotifier({required ICreditCardSave creditCardSave, required ICreditCardDelete creditCardDelete})
      : _creditCardSave = creditCardSave,
        _creditCardDelete = creditCardDelete,
        super(CreditCardState.start());

  CreditCardEntity get creditCard => value.creditCard;

  bool get isLoading => value is SavingCreditCardState || value is DeletingCreditCardState;

  void setCreditCard(CreditCardEntity creditCard) => value = value.setCreditCard(creditCard);

  void setAccount(String idAccount) {
    creditCard.idAccount = idAccount;
    value = value.changedCreditCard();
  }

  void setCardBrand(CardBrandEnum? cardBrand) async {
    value.creditCard.brand = cardBrand;
    value = value.changedCreditCard();
  }

  Future<void> save() async {
    try {
      value = value.setSaving();
      await _creditCardSave.save(creditCard);
      value = value.changedCreditCard();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      value = value.setDeleting();
      await _creditCardDelete.delete(creditCard);
      value = value.changedCreditCard();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
