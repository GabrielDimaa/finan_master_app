sealed class HomeAccountsBalanceState {
  final double balance;

  const HomeAccountsBalanceState({required this.balance});

  factory HomeAccountsBalanceState.start() => const StartHomeAccountsBalanceState();

  HomeAccountsBalanceState setLoading() => LoadingHomeAccountsBalanceState(balance: balance);

  HomeAccountsBalanceState setBalance(double balance) => LoadedHomeAccountsBalanceState(balance: balance);

  HomeAccountsBalanceState setError(String message) => ErrorHomeAccountsBalanceState(message, balance: balance);
}

class StartHomeAccountsBalanceState extends HomeAccountsBalanceState {
  const StartHomeAccountsBalanceState() : super(balance: 0);
}

class LoadingHomeAccountsBalanceState extends HomeAccountsBalanceState {
  const LoadingHomeAccountsBalanceState({required super.balance});
}

class LoadedHomeAccountsBalanceState extends HomeAccountsBalanceState {
  const LoadedHomeAccountsBalanceState({required super.balance});
}

class ErrorHomeAccountsBalanceState extends HomeAccountsBalanceState {
  final String message;

  const ErrorHomeAccountsBalanceState(this.message, {required super.balance});
}
