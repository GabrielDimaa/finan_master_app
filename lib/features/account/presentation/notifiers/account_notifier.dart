import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/adjustment_option_enum.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/account/presentation/states/account_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class AccountNotifier extends ValueNotifier<AccountState> {
  final IAccountFind _accountFind;
  final IAccountSave _accountSave;
  final IAccountDelete _accountDelete;
  final IIncomeSave _incomeSave;
  final IExpenseSave _expenseSave;

  AccountNotifier({required IAccountFind accountFind, required IAccountSave accountSave, required IAccountDelete accountDelete, required IIncomeSave incomeSave, required IExpenseSave expenseSave})
      : _accountFind = accountFind,
        _accountSave = accountSave,
        _accountDelete = accountDelete,
        _incomeSave = incomeSave,
        _expenseSave = expenseSave,
        super(AccountState.start());

  AccountEntity get account => value.account;

  bool get isLoading => value is SavingAccountState || value is DeletingAccountState || value is FindingAccountState;

  void setAccount(AccountEntity account) => value = value.setAccount(account);

  void setFinancialInstitution(FinancialInstitutionEnum? financialInstitution) async {
    value.account.financialInstitution = financialInstitution;
    value = value.changedAccount();
  }

  void setIncludeTotalBalance(bool? include) {
    value.account.includeTotalBalance = include ?? false;
    value = value.changedAccount();
  }

  Future<void> save() async {
    try {
      value = value.setSaving();
      await _accountSave.save(account);
      value = value.changedAccount();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      value = value.setDeleting();
      await _accountDelete.delete(account);
      value = value.changedAccount();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> readjustBalance({required double readjustmentValue, required ReadjustmentOptionEnum option, required String description}) async {
    try {
      value = value.setSaving();

      if (option == ReadjustmentOptionEnum.changeInitialAmount) {
        final AccountEntity accountSaved = await _accountSave.changeInitialAmount(entity: account, readjustmentValue: readjustmentValue);
        value = value.setAccount(accountSaved);
      } else {
        if (readjustmentValue > 0) {
          final IncomeEntity income = IncomeEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: description,
            observation: null,
            idCategory: categoryOthersUuidIncome,
            transaction: null,
          );

          income.amount = readjustmentValue.abs();
          income.transaction.idAccount = account.id;

          await _incomeSave.save(income);
        } else {
          final ExpenseEntity expense = ExpenseEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: description,
            observation: null,
            idCategory: categoryOthersUuidExpense,
            transaction: null,
          );

          expense.amount = readjustmentValue.abs();
          expense.transaction.idAccount = account.id;

          await _expenseSave.save(expense);
        }

        value = value.changedAccount();
      }
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> findById(String id) async {
    try {
      value = value.setFinding();

      final AccountEntity? account = await _accountFind.findById(id);
      if (account == null) throw Exception(R.strings.accountNotFound);

      value = value.setAccount(account);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
