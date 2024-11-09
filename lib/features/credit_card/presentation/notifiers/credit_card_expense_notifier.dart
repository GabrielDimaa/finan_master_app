import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_expense_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';
import 'package:flutter/foundation.dart';

class CreditCardExpenseNotifier extends ValueNotifier<CreditCardExpenseState> {
  final ICreditCardTransactionSave _creditCardTransactionSave;
  final ICreditCardTransactionDelete _creditCardTransactionDelete;
  final IExpenseFind _expenseFind;

  CreditCardExpenseNotifier({
    required ICreditCardTransactionSave creditCardTransactionSave,
    required ICreditCardTransactionDelete creditCardTransactionDelete,
    required IExpenseFind expenseFind,
  })  : _creditCardTransactionSave = creditCardTransactionSave,
        _creditCardTransactionDelete = creditCardTransactionDelete,
        _expenseFind = expenseFind,
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
    try {
      value = value.setDeleting();
      await _creditCardTransactionDelete.delete(creditCardExpense);
      value = value.changedCreditCardExpense();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<List<TransactionByTextEntity>> findByText(String text) => _expenseFind.findByText(text);
}
