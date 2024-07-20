import 'package:finan_master_app/features/home/domain/entities/home_monthly_balance_entity.dart';
import 'package:finan_master_app/features/home/domain/repositories/i_home_monthly_balance_repository.dart';
import 'package:finan_master_app/features/home/domain/usecases/i_home_monthly_balance.dart';

class HomeMonthlyBalance implements IHomeMonthlyBalance {
  final IHomeMonthlyBalanceRepository _repository;

  HomeMonthlyBalance({required IHomeMonthlyBalanceRepository repository}) : _repository = repository;

  @override
  Future<List<HomeMonthlyBalanceEntity>> findMonthlyBalances({required DateTime startDate, required DateTime endDate}) => _repository.findMonthlyBalances(startDate: startDate, endDate: endDate);
}