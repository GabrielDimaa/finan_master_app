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
      final List<HomeMonthlyBalanceEntity> monthlyBalances = await _monthlyBalance.findMonthlyBalances(startDate: now.subtractMonths(5).getInitialMonth(), endDate: now.getFinalMonth());

      value = value.setMonthlyBalances(monthlyBalances);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
