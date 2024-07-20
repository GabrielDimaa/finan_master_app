import 'package:finan_master_app/features/home/domain/entities/home_monthly_balance_entity.dart';

sealed class HomeMonthlyBalanceState {
  final List<HomeMonthlyBalanceEntity> monthlyBalances;

  const HomeMonthlyBalanceState({required this.monthlyBalances});

  factory HomeMonthlyBalanceState.start() => const StartHomeMonthlyBalanceState();

  HomeMonthlyBalanceState setLoading() => LoadingHomeMonthlyBalanceState(monthlyBalances: monthlyBalances);

  HomeMonthlyBalanceState setMonthlyBalances(List<HomeMonthlyBalanceEntity> monthlyBalances) => LoadedHomeMonthlyBalanceState(monthlyBalances: monthlyBalances);

  HomeMonthlyBalanceState setError(String message) => ErrorHomeMonthlyBalanceState(message, monthlyBalances: monthlyBalances);
}

class StartHomeMonthlyBalanceState extends HomeMonthlyBalanceState {
  const StartHomeMonthlyBalanceState() : super(monthlyBalances: const []);
}

class LoadingHomeMonthlyBalanceState extends HomeMonthlyBalanceState {
  const LoadingHomeMonthlyBalanceState({required super.monthlyBalances});
}

class LoadedHomeMonthlyBalanceState extends HomeMonthlyBalanceState {
  const LoadedHomeMonthlyBalanceState({required super.monthlyBalances});
}

class ErrorHomeMonthlyBalanceState extends HomeMonthlyBalanceState {
  final String message;

  const ErrorHomeMonthlyBalanceState(this.message, {required super.monthlyBalances});
}
