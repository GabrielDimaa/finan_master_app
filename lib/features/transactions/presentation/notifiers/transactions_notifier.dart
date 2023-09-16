import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_find.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:flutter/foundation.dart';

class TransactionsNotifier extends ValueNotifier<TransactionsState> {
  final IExpenseFind _expenseFind;
  final IIncomeFind _incomeFind;
  final ITransferFind _transferFind;

  TransactionsNotifier({
    required IExpenseFind expenseFind,
    required IIncomeFind incomeFind,
    required ITransferFind transferFind,
  })  : _transferFind = transferFind,
        _incomeFind = incomeFind,
        _expenseFind = expenseFind,
        super(TransactionsState.start());

  Future<void> findByPeriod(DateTime startDate, DateTime endDate) async {
    try {
      value = value.setLoading();

      final List<IFinancialOperation> transactions = [];

      await Future.wait([
        Future(() async => transactions.addAll(await _expenseFind.findByPeriod(startDate, endDate))),
        Future(() async => transactions.addAll(await _incomeFind.findByPeriod(startDate, endDate))),
        Future(() async => transactions.addAll(await _transferFind.findByPeriod(startDate, endDate))),
      ]);

      value = value.setTransactions(transactions);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
