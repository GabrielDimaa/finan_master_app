sealed class HomeTransactionsUnpaidUnreceivedState {
  final double amountsIncome;
  final double amountsExpense;

  const HomeTransactionsUnpaidUnreceivedState({required this.amountsIncome, required this.amountsExpense});

  factory HomeTransactionsUnpaidUnreceivedState.start() => const StartHomeTransactionsUnpaidUnreceivedState();

  HomeTransactionsUnpaidUnreceivedState setLoading() => LoadingHomeTransactionsUnpaidUnreceivedState(amountsIncome: amountsIncome, amountsExpense: amountsExpense);

  HomeTransactionsUnpaidUnreceivedState setAmounts({required double amountsIncome, required double amountsExpense}) => LoadedHomeTransactionsUnpaidUnreceivedState(amountsIncome: amountsIncome, amountsExpense: amountsExpense);

  HomeTransactionsUnpaidUnreceivedState setError(String message) => ErrorHomeTransactionsUnpaidUnreceivedState(message, amountsIncome: amountsIncome, amountsExpense: amountsExpense);
}

class StartHomeTransactionsUnpaidUnreceivedState extends HomeTransactionsUnpaidUnreceivedState {
  const StartHomeTransactionsUnpaidUnreceivedState() : super(amountsExpense: 0, amountsIncome: 0);
}

class LoadingHomeTransactionsUnpaidUnreceivedState extends HomeTransactionsUnpaidUnreceivedState {
  const LoadingHomeTransactionsUnpaidUnreceivedState({required super.amountsIncome, required super.amountsExpense});
}

class LoadedHomeTransactionsUnpaidUnreceivedState extends HomeTransactionsUnpaidUnreceivedState {
  const LoadedHomeTransactionsUnpaidUnreceivedState({required super.amountsIncome, required super.amountsExpense});
}

class ErrorHomeTransactionsUnpaidUnreceivedState extends HomeTransactionsUnpaidUnreceivedState {
  final String message;

  const ErrorHomeTransactionsUnpaidUnreceivedState(this.message, {required super.amountsIncome, required super.amountsExpense});
}
