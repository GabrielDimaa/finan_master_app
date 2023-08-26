import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class AccountSave implements IAccountSave {
  final IAccountRepository _repository;

  AccountSave({required IAccountRepository repository}) : _repository = repository;

  @override
  Future<AccountEntity> save(AccountEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.initialValue < 0) throw ValidationException(R.strings.smallerThanZero);
    if (entity.financialInstitution == null) return throw ValidationException(R.strings.uninformedFinancialInstitution);

    if (entity.isNew) {
      entity.balance = entity.initialValue;
    }

    return await _repository.save(entity);
  }

  @override
  Future<AccountEntity> readjustBalance(AccountEntity entity, readjustmentValue) async {
    if (readjustmentValue < 0) throw ValidationException(R.strings.smallerThanZero);

    entity.initialValue = readjustmentValue;
    entity.balance = readjustmentValue;

    return await save(entity);
  }
}
