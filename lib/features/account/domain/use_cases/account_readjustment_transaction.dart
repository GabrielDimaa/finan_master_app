import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_readjustment_transaction.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class AccountReadjustmentTransaction implements IAccountReadjustmentTransaction {
  final IIncomeSave _incomeSave;
  final IExpenseSave _expenseSave;
  final IAccountRepository _repository;

  AccountReadjustmentTransaction({
    required IIncomeSave incomeSave,
    required IExpenseSave expenseSave,
    required IAccountRepository repository,
  })
      : _incomeSave = incomeSave,
        _expenseSave = expenseSave,
        _repository = repository;

  @override
  Future<AccountEntity> createTransaction({required AccountEntity account, required double readjustmentValue, required String description}) async {
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
        idCreditCardTransaction: null,
        transaction: null,
      );

      expense.amount = readjustmentValue.abs();
      expense.transaction.idAccount = account.id;

      await _expenseSave.save(expense);
    }

    return await _repository.findById(account.id) ?? (account);
  }
}
