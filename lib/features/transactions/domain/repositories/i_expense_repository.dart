import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';

abstract interface class IExpenseRepository {
  Future<ExpenseEntity> save(ExpenseEntity entity);
}
