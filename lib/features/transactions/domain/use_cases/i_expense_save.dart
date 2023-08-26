import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';

abstract interface class IExpenseSave {
  Future<ExpenseEntity> save(ExpenseEntity entity);
}
