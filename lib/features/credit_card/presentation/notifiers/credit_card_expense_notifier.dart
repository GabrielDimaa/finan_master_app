import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_expense_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardExpenseNotifier extends ValueNotifier<CreditCardExpenseState> {
  final ICreditCardTransactionSave _creditCardTransactionSave;

  CreditCardExpenseNotifier({required ICreditCardTransactionSave creditCardTransactionSave})
      : _creditCardTransactionSave = creditCardTransactionSave,
        super(CreditCardExpenseState.start());

  CreditCardTransactionEntity get creditCardExpense => value.creditCardExpense;

  bool get isLoading => value is SavingCreditCardExpenseState || value is DeletingCreditCardExpenseState;

  void setCategory(String idCategory) {
    creditCardExpense.idCategory = idCategory;
    value = value.changedCreditCardExpense();
  }

  void setCreditCard(String idCreditCard) {
    creditCardExpense.idCreditCard = idCreditCard;
    value = value.changedCreditCardExpense();
  }

  void setDate(DateTime date) {
    creditCardExpense.date = date;
    value = value.changedCreditCardExpense();
  }

  void setCreditCardExpense(CreditCardTransactionEntity expense) {
    value = value.setCreditCardExpense(expense);
  }

  Future<void> save() async {
    try {
      value = value.setSaving();
      await _creditCardTransactionSave.save(creditCardExpense);
      value = value.changedCreditCardExpense();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> delete() async {
    throw UnimplementedError();
  }
}
