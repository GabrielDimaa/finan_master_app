import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';

sealed class TransactionsUnpaidUnreceivedState {
  final List<ITransactionEntity> transactions;

  const TransactionsUnpaidUnreceivedState({required this.transactions});

  factory TransactionsUnpaidUnreceivedState.start() => StartTransactionsUnpaidUnreceivedState();

  TransactionsUnpaidUnreceivedState setLoading() => LoadingTransactionsUnpaidUnreceivedState(transactions: transactions);

  TransactionsUnpaidUnreceivedState setTransactions(List<ITransactionEntity> list) => list.isEmpty ? EmptyTransactionsUnpaidUnreceivedState(transactions: list) : ListTransactionsUnpaidUnreceivedState(transactions: list);

  TransactionsUnpaidUnreceivedState setError(String message) => ErrorTransactionsUnpaidUnreceivedState(message: message, transactions: transactions);
}

class StartTransactionsUnpaidUnreceivedState extends TransactionsUnpaidUnreceivedState {
  StartTransactionsUnpaidUnreceivedState() : super(transactions: []);
}

class ListTransactionsUnpaidUnreceivedState extends TransactionsUnpaidUnreceivedState {
  const ListTransactionsUnpaidUnreceivedState({required super.transactions});
}

class EmptyTransactionsUnpaidUnreceivedState extends TransactionsUnpaidUnreceivedState {
  const EmptyTransactionsUnpaidUnreceivedState({required super.transactions});
}

class LoadingTransactionsUnpaidUnreceivedState extends TransactionsUnpaidUnreceivedState {
  const LoadingTransactionsUnpaidUnreceivedState({required super.transactions});
}

class ErrorTransactionsUnpaidUnreceivedState extends TransactionsUnpaidUnreceivedState {
  final String message;

  const ErrorTransactionsUnpaidUnreceivedState({required this.message, required super.transactions});
}
