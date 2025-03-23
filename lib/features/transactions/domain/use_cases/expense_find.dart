import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';

class ExpenseFind implements IExpenseFind {
  final IExpenseRepository _repository;

  ExpenseFind({required IExpenseRepository repository}) : _repository = repository;

  @override
  Future<List<TransactionByTextEntity>> findByText(String text) => _repository.findByText(text);
}
