import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';

abstract interface class IExpenseFind {
  Future<List<ExpenseEntity>> findByText(String text);
}
