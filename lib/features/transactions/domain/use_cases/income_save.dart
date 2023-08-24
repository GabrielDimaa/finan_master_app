import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class IncomeSave implements IIncomeSave {
  final IIncomeRepository _repository;

  IncomeSave({required IIncomeRepository repository}) : _repository = repository;

  @override
  Future<Result<IncomeEntity, BaseException>> save(IncomeEntity entity) async {
    if (entity.description.trim().isEmpty) return Result.failure(ValidationException(R.strings.description, null));
    if (entity.value <= 0) return Result.failure(ValidationException(R.strings.greaterThanZero, null));
    if (entity.category == null) return Result.failure(ValidationException(R.strings.uninformedCategory, null));
    if (entity.account == null) return Result.failure(ValidationException(R.strings.uninformedAccount, null));

    // TODO: implement save
    throw UnimplementedError();
  }
}
