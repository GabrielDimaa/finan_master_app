sealed class HomeMonthlyTransactionState {
  final double amountsIncome;
  final double amountsExpense;

  const HomeMonthlyTransactionState({required this.amountsIncome, required this.amountsExpense});

  factory HomeMonthlyTransactionState.start() => const StartHomeMonthlyTransactionState();

  HomeMonthlyTransactionState setLoading() => LoadingHomeMonthlyTransactionState(amountsIncome: amountsIncome, amountsExpense: amountsExpense);

  HomeMonthlyTransactionState setAmounts({required double amountsIncome, required double amountsExpense}) => LoadedHomeMonthlyTransactionState(amountsIncome: amountsIncome, amountsExpense: amountsExpense);

  HomeMonthlyTransactionState setError(String message) => ErrorHomeMonthlyTransactionState(message, amountsIncome: amountsIncome, amountsExpense: amountsExpense);
}

class StartHomeMonthlyTransactionState extends HomeMonthlyTransactionState {
  const StartHomeMonthlyTransactionState() : super(amountsExpense: 0, amountsIncome: 0);
}

class LoadingHomeMonthlyTransactionState extends HomeMonthlyTransactionState {
  const LoadingHomeMonthlyTransactionState({required super.amountsIncome, required super.amountsExpense});
}

class LoadedHomeMonthlyTransactionState extends HomeMonthlyTransactionState {
  const LoadedHomeMonthlyTransactionState({required super.amountsIncome, required super.amountsExpense});
}

class ErrorHomeMonthlyTransactionState extends HomeMonthlyTransactionState {
  final String message;

  const ErrorHomeMonthlyTransactionState(this.message, {required super.amountsIncome, required super.amountsExpense});
}
