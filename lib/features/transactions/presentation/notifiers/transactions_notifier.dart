import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:flutter/foundation.dart';

class TransactionsNotifier extends ValueNotifier<TransactionsState> {
  final ITransactionFind _transactionFind;

  TransactionsNotifier({required ITransactionFind transactionFind})
      : _transactionFind = transactionFind,
        super(TransactionsState.start());

  Future<void> findByPeriod(DateTime startDate, DateTime endDate) async {
    try {
      value = value.setLoading();

      final List<IFinancialOperationEntity> transactions = await _transactionFind.findByPeriod(startDate, endDate);

      value = value.setTransactions(transactions);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
