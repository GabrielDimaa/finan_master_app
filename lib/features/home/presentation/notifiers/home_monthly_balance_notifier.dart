import 'package:finan_master_app/features/home/domain/entities/home_monthly_balance_entity.dart';
import 'package:finan_master_app/features/home/domain/usecases/i_home_monthly_balance.dart';
import 'package:finan_master_app/features/home/presentation/states/home_monthly_balance_state.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:flutter/cupertino.dart';

class HomeMonthlyBalanceNotifier extends ValueNotifier<HomeMonthlyBalanceState> {
  final IHomeMonthlyBalance _monthlyBalance;

  HomeMonthlyBalanceNotifier({required IHomeMonthlyBalance monthlyBalance})
      : _monthlyBalance = monthlyBalance,
        super(const StartHomeMonthlyBalanceState());

  List<HomeMonthlyBalanceEntity> get monthlyBalances => value.monthlyBalances;

  Future<void> load() async {
    try {
      value = value.setLoading();

      final DateTime now = DateTime.now();
      final DateTime startMonth = now.subtractMonths(5).getInitialMonth();
      final DateTime endMonth = now.getFinalMonth();

      final List<HomeMonthlyBalanceEntity> results = await _monthlyBalance.findMonthlyBalances(startDate: startMonth, endDate: endMonth);

      List<HomeMonthlyBalanceEntity> monthlyBalances = [];

      for (int i = 0; i < 6; i++) {
        final DateTime date = i == 0 ? now : now.subtractMonths(i);

        monthlyBalances.add(
          results.firstWhere(
            (e) => e.date.year == date.year && e.date.month == date.month,
            orElse: () => HomeMonthlyBalanceEntity(date: date.getInitialMonth(), balance: 0),
          ),
        );
      }

      value = value.setMonthlyBalances(monthlyBalances.reversed.toList());
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
