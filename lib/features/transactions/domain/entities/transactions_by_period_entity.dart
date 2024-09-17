import 'package:collection/collection.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';

class TransactionsByPeriodEntity {
  final List<ITransactionEntity> transactions;

  double get amountsIncome => transactions.map((transaction) => transaction is IncomeEntity ? transaction.amount : 0).sum.toDouble();

  double get amountsExpense => transactions.map((transaction) => transaction is ExpenseEntity ? transaction.amount : 0).sum.toDouble();

  //amountsExpense terá valor negativo, portanto, 10000 + (-100).
  double get balance => amountsIncome + amountsExpense;

  TransactionsByPeriodEntity({required this.transactions});
}
