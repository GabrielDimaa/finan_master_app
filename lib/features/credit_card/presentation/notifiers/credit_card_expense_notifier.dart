import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_expense_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:flutter/foundation.dart';

class CreditCardExpenseNotifier extends ValueNotifier<CreditCardExpenseState> {
  final ICreditCardTransactionSave _creditCardTransactionSave;
  final ICreditCardTransactionDelete _creditCardTransactionDelete;
  final ITransactionFind _transactionFind;

  CreditCardExpenseNotifier({
    required ICreditCardTransactionSave creditCardTransactionSave,
    required ICreditCardTransactionDelete creditCardTransactionDelete,
    required ITransactionFind transactionFind,
  })  : _creditCardTransactionSave = creditCardTransactionSave,
        _creditCardTransactionDelete = creditCardTransactionDelete,
        _transactionFind = transactionFind,
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

  Future<List<ExpenseEntity>> findByText(String text) async => (await _transactionFind.findByText(categoryType: CategoryTypeEnum.expense, text: text)).map((e) => e as ExpenseEntity).toList();
}
