import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_delete.dart';

class IncomeDelete implements IIncomeDelete {
  final IIncomeRepository _repository;

  IncomeDelete({required IIncomeRepository repository}) : _repository = repository;

  @override
  Future<void> delete(IncomeEntity entity) => _repository.delete(entity);
}
