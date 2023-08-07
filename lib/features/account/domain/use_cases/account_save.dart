import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class AccountSave implements IAccountSave {
  final IAccountRepository _repository;

  AccountSave({required IAccountRepository repository}) : _repository = repository;

  @override
  Future<Result<AccountEntity, BaseException>> save(AccountEntity entity) async {
    if (entity.description.isEmpty) return Result.failure(ValidationException(R.strings.uninformedDescription, null));
    if (entity.initialValue < 0) return Result.failure(ValidationException(R.strings.smallerThanZero, null));
    if (entity.financialInstitution == null) return Result.failure(ValidationException(R.strings.uninformedFinancialInstitution, null));

    return await _repository.save(entity);
  }
}
