import 'dart:core';

import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:flutter/foundation.dart';

class TransactionsNotifier extends ValueNotifier<TransactionsState> {
  final ITransactionFind _transactionFind;
  final IAccountFind _accountFind;

  TransactionsNotifier({required ITransactionFind transactionFind, required IAccountFind accountFind})
      : _transactionFind = transactionFind,
        _accountFind = accountFind,
        super(TransactionsState.start()) {
    final DateTime dateNow = DateTime.now();
    startDate = DateTime(dateNow.year, dateNow.month, 1);
    endDate = DateTime(dateNow.year, dateNow.month, dateNow.getLastDayInMonth(), 23, 59, 59, 59);
  }

  TransactionsByPeriodEntity transactionsByPeriod = TransactionsByPeriodEntity(transactions: []);
  double monthlyBalanceCumulative = 0;

  late DateTime startDate;
  late DateTime endDate;
  Set<CategoryTypeEnum?> filterType = {null};

  Future<void> findByPeriod(DateTime startDate, DateTime endDate) async {
    try {
      value = value.setLoading();

      this.startDate = startDate;
      this.endDate = endDate;

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

  Future<void> refreshTransactions() => findByPeriod(startDate, endDate);
}
