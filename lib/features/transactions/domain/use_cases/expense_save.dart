import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class ExpenseSave implements IExpenseSave {
  final IExpenseRepository _repository;

  ExpenseSave({required IExpenseRepository repository}) : _repository = repository;

  @override
  Future<ExpenseEntity> save(ExpenseEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.idCategory == null) throw ValidationException(R.strings.uninformedCategory);
    if (entity.transaction.amount >= 0) throw ValidationException(R.strings.lessThanZero);
    if (entity.transaction.idAccount == null) throw ValidationException(R.strings.uninformedAccount);

    return await _repository.save(entity);
  }
}
