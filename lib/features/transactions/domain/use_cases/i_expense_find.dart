import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';

abstract interface class IExpenseFind {
  Future<List<TransactionByTextEntity>> findByText(String text);

  Future<ExpenseEntity?> findById(String id);
}
