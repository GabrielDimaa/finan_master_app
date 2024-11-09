import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_find.dart';

class IncomeFind implements IIncomeFind {
  final IIncomeRepository _repository;

  IncomeFind({required IIncomeRepository repository}) : _repository = repository;

  @override
  Future<List<TransactionByTextEntity>> findByText(String text) => _repository.findByText(text);
}
