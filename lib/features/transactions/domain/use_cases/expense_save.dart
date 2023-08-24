import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class ExpenseSave implements IExpenseSave {
  final IExpenseRepository _repository;

  ExpenseSave({required IExpenseRepository repository}) : _repository = repository;

  @override
  Future<Result<ExpenseEntity, BaseException>> save(ExpenseEntity entity) async {
    if (entity.description.trim().isEmpty) return Result.failure(ValidationException(R.strings.description, null));
    if (entity.value <= 0) return Result.failure(ValidationException(R.strings.greaterThanZero, null));
    if (entity.category == null) return Result.failure(ValidationException(R.strings.uninformedCategory, null));
    if (entity.account == null) return Result.failure(ValidationException(R.strings.uninformedAccount, null));

    // TODO: implement save
    throw UnimplementedError();
  }
}
