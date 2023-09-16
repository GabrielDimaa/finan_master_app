import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_find.dart';

class IncomeFind implements IIncomeFind {
  final IIncomeRepository _repository;

  IncomeFind({required IIncomeRepository repository}) : _repository = repository;

  @override
  Future<List<IncomeEntity>> findByPeriod(DateTime start, DateTime end) => _repository.findByPeriod(start, end);
}
