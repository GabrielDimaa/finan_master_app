import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/features/transactions/presentation/states/income_state.dart';
import 'package:flutter/foundation.dart';

class IncomeNotifier extends ValueNotifier<IncomeState> {
  final IIncomeSave _incomeSave;

  IncomeNotifier({required IIncomeSave incomeSave})
      : _incomeSave = incomeSave,
        super(IncomeState.start());

  IncomeEntity get income => value.income;

  bool get isLoading => value is SavingIncomeState || value is DeletingIncomeState;

  void updateExpense(IncomeEntity income) => value = value.updateIncome(income);

  void setCategory(String idCategory) {
    income.idCategory = idCategory;
    value = value.changedIncome();
  }

  void setAccount(String idAccount) {
    income.transaction.idAccount = idAccount;
    value = value.changedIncome();
  }

  void setDate(DateTime date) {
    income.transaction.date = date;
    value = value.changedIncome();
  }

  Future<IncomeEntity> save() async {
    value = value.setSaving();
    return await _incomeSave.save(income);
  }
}
