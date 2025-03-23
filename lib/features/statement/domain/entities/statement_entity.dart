import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class StatementEntity extends Entity {
  double amount;
  DateTime date;

  String idAccount;

  String? idExpense;
  String? idIncome;
  String? idTransfer;

  StatementEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.amount,
    required this.date,
    required this.idAccount,
    required this.idExpense,
    required this.idIncome,
    required this.idTransfer,
  });

  void updateFromExpense(ExpenseEntity expense) {
    amount = expense.amount;
    date = expense.date;
    idAccount = expense.idAccount ?? idAccount;
    idExpense = expense.id;
    idIncome = null;
    idTransfer = null;
  }

  void updateFromIncome(IncomeEntity income) {
    amount = income.amount;
    date = income.date;
    idAccount = income.idAccount ?? idAccount;
    idExpense = null;
    idIncome = income.id;
    idTransfer = null;
  }

  void updateFromTransfer(TransferEntity transfer) {
    final bool isNegative = amount < 0;

    amount = isNegative ? -transfer.amount : transfer.amount;
    date = transfer.date;
    idAccount = isNegative ? transfer.idAccountFrom! : transfer.idAccountTo!;
    idExpense = null;
    idIncome = null;
    idTransfer = transfer.id;
  }
}
