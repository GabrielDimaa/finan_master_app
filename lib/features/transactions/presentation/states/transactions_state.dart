import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation.dart';

sealed class TransactionsState {
  final List<IFinancialOperation> transactions;

  const TransactionsState({required this.transactions});

  factory TransactionsState.start() => StartTransactionsState();

  TransactionsState setLoading() => LoadingTransactionsState(transactions: transactions);

  TransactionsState setTransactions(List<IFinancialOperation> transactions) => transactions.isEmpty ? EmptyTransactionsState(transactions: transactions) : ListTransactionsState(transactions: transactions);

  TransactionsState setError(String message) => ErrorTransactionsState(message: message, transactions: transactions);
}

class StartTransactionsState extends TransactionsState {
  StartTransactionsState() : super(transactions: []);
}

class ListTransactionsState extends TransactionsState {
  const ListTransactionsState({required super.transactions});
}

class EmptyTransactionsState extends TransactionsState {
  const EmptyTransactionsState({required super.transactions});
}

class LoadingTransactionsState extends TransactionsState {
  const LoadingTransactionsState({required super.transactions});
}

class ErrorTransactionsState extends TransactionsState {
  final String message;

  const ErrorTransactionsState({required this.message, required super.transactions});
}
