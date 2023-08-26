import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class IncomeSave implements IIncomeSave {
  final IIncomeRepository _repository;

  IncomeSave({required IIncomeRepository repository}) : _repository = repository;

  @override
  Future<IncomeEntity> save(IncomeEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.description);
    if (entity.value <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.category == null) throw ValidationException(R.strings.uninformedCategory);
    if (entity.account == null) throw ValidationException(R.strings.uninformedAccount);

    // TODO: implement save
    throw UnimplementedError();
  }
}
