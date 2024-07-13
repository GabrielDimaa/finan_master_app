import 'package:finan_master_app/features/home/presentation/states/home_monthly_transaction_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:flutter/foundation.dart';

class HomeMonthlyTransactionNotifier extends ValueNotifier<HomeMonthlyTransactionState> {
  final ITransactionFind _transactionFind;

  HomeMonthlyTransactionNotifier(ITransactionFind transactionFind)
      : _transactionFind = transactionFind,
        super(HomeMonthlyTransactionState.start());

  Future<void> load() async {
    try {
      value = value.setLoading();

      final DateTime dateNow = DateTime.now();
      final TransactionsByPeriodEntity transactions = await _transactionFind.findByPeriod(dateNow.getInitialMonth(), dateNow.getFinalMonth());

      value = value.setAmounts(amountsIncome: transactions.amountsIncome, amountsExpense: transactions.amountsExpense);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
