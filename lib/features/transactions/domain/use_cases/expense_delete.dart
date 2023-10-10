import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';

class ExpenseDelete implements IExpenseDelete {
  final IExpenseRepository _repository;

  ExpenseDelete({required IExpenseRepository repository}) : _repository = repository;

  @override
  Future<void> delete(ExpenseEntity entity) => _repository.delete(entity);
}
