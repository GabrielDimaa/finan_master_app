import 'package:collection/collection.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_unpaid_unreceived_state.dart';
import 'package:flutter/foundation.dart';

class TransactionsUnpaidUnreceivedNotifier extends ValueNotifier<TransactionsUnpaidUnreceivedState> {
  final ITransactionFind _transactionFind;
  final ITransactionDelete _transactionDelete;

  TransactionsUnpaidUnreceivedNotifier({
    required ITransactionFind transactionFind,
    required ITransactionDelete transactionDelete,
  })  : _transactionFind = transactionFind,
        _transactionDelete = transactionDelete,
        super(TransactionsUnpaidUnreceivedState.start());

  List<ITransactionEntity> get transactions => value.transactions;

  double get totalPaidOrReceived => transactions.map((e) => isPaidOrReceived(e) ? e.amount : 0.0).sum.toDouble();
  double get totalPayableOrReceivable => transactions.map((e) => isPaidOrReceived(e) ? 0.0 : e.amount).sum.toDouble();

  Future<void> load(CategoryTypeEnum type) async {
    try {
      value = value.setLoading();

      value = value.setTransactions(await _transactionFind.findUnpaidUnreceived(type: type));
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> deleteTransactions(List<ITransactionEntity> transactions) async {
    await _transactionDelete.deleteTransactions(transactions);

    setTransactions(value.transactions.where((e) => !transactions.any((t) => t.id == e.id)).toList());
  }

  bool isPaidOrReceived(ITransactionEntity transaction) {
    return transaction is ExpenseEntity ? transaction.paid : (transaction as IncomeEntity).received;
  }

  void setTransactions(List<ITransactionEntity> list) {
    value = value.setTransactions(list);
  }
}