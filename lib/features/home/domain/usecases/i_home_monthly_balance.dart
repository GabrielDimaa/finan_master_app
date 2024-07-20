import 'package:finan_master_app/features/home/domain/entities/home_monthly_balance_entity.dart';

abstract interface class IHomeMonthlyBalance {
  Future<List<HomeMonthlyBalanceEntity>> findMonthlyBalances({required DateTime startDate, required DateTime endDate});
}
