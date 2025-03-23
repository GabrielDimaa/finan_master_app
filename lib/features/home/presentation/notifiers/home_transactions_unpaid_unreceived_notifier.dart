import 'package:collection/collection.dart';
import 'package:finan_master_app/features/home/presentation/states/home_transactions_unpaid_unreceived_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:flutter/foundation.dart';

class HomeTransactionsUnpaidUnreceivedNotifier extends ValueNotifier<HomeTransactionsUnpaidUnreceivedState> {
  final ITransactionFind _transactionFind;

  HomeTransactionsUnpaidUnreceivedNotifier({required ITransactionFind transactionFind})
      : _transactionFind = transactionFind,
        super(HomeTransactionsUnpaidUnreceivedState.start());

  Future<void> load() async {
    try {
      value = value.setLoading();

      final List<ITransactionEntity> transactions = await _transactionFind.findUnpaidUnreceived();

      value = value.setAmounts(
        amountsIncome: transactions.map((transaction) => transaction is IncomeEntity && !transaction.received ? transaction.amount : 0).sum.toDouble(),
        amountsExpense: transactions.map((transaction) => transaction is ExpenseEntity && !transaction.paid ? transaction.amount : 0).sum.toDouble(),
      );
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
