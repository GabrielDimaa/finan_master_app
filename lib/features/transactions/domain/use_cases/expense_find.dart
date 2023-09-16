import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';

class ExpenseFind implements IExpenseFind {
  final IExpenseRepository _repository;

  ExpenseFind({required IExpenseRepository repository}) : _repository = repository;

  @override
  Future<List<ExpenseEntity>> findByPeriod(DateTime start, DateTime end) => _repository.findByPeriod(start, end);
}
