import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:flutter/foundation.dart';

class TransactionsNotifier extends ValueNotifier<TransactionsState> {
  final ITransactionFind _transactionFind;
  final IAccountFind _accountFind;

  TransactionsNotifier({required ITransactionFind transactionFind, required IAccountFind accountFind})
      : _transactionFind = transactionFind,
        _accountFind = accountFind,
        super(TransactionsState.start());

  TransactionsByPeriodEntity transactionsByPeriod = TransactionsByPeriodEntity(transactions: []);
  double monthlyBalanceCumulative = 0;

  Set<CategoryTypeEnum?> filterType = {null};

  Future<void> findByPeriod(DateTime startDate, DateTime endDate) async {
    try {
      value = value.setLoading();

      transactionsByPeriod = await _transactionFind.findByPeriod(startDate, endDate);
      monthlyBalanceCumulative = await _accountFind.findBalanceUntilDate(endDate);

      filterTransactions(filterType);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  void filterTransactions(Set<CategoryTypeEnum?> type) {
    filterType = type;

    if (type.firstOrNull == null) {
      value = value.setTransactions(transactionsByPeriod.transactions);
      return;
    }

    value = value.setTransactions(transactionsByPeriod.transactions.where((transaction) => transaction.categoryType == type.first).toList());
  }
}
