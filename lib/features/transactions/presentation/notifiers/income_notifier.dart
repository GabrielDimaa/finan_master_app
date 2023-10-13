import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/features/transactions/presentation/states/income_state.dart';
import 'package:flutter/foundation.dart';

class IncomeNotifier extends ValueNotifier<IncomeState> {
  final IIncomeSave _incomeSave;
  final IIncomeDelete _incomeDelete;

  IncomeNotifier({required IIncomeSave incomeSave, required IIncomeDelete incomeDelete})
      : _incomeSave = incomeSave,
        _incomeDelete = incomeDelete,
        super(IncomeState.start());

  IncomeEntity get income => value.income;

  bool get isLoading => value is SavingIncomeState || value is DeletingIncomeState;

  void setIncome(IncomeEntity income) => value = value.setIncome(income);

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

  Future<void> save() async {
    try {
      value = value.setSaving();
      await _incomeSave.save(income);
      value = value.changedIncome();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      value = value.setDeleting();
      await _incomeDelete.delete(income);
      value = value.changedIncome();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
