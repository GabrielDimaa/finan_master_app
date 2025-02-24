import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_readjustment_transaction.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/shared/classes/constants.dart';

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
        amount: readjustmentValue.abs(),
        date: DateTime.now(),
        paid: true,
        observation: null,
        idAccount: account.id,
        idCategory: categoryOthersUuidIncome,
      );

      await _incomeSave.save(income);
    } else {
      final ExpenseEntity expense = ExpenseEntity(
        id: null,
        createdAt: null,
        deletedAt: null,
        description: description,
        amount: readjustmentValue.abs(),
        date: DateTime.now(),
        paid: true,
        observation: null,
        idAccount: account.id,
        idCategory: categoryOthersUuidExpense,
        idCreditCard: null,
        idCreditCardTransaction: null,
      );

      await _expenseSave.save(expense);
    }

    return await _repository.findById(account.id) ?? (account);
  }
}
