import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class AccountSave implements IAccountSave {
  final IAccountRepository _repository;
  final IAdAccess _adAccess;

  AccountSave({required IAccountRepository repository, required IAdAccess adAccess}) : _repository = repository, _adAccess = adAccess;

  @override
  Future<AccountEntity> save(AccountEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.isNew && entity.initialAmount < 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.financialInstitution == null) return throw ValidationException(R.strings.uninformedFinancialInstitution);

    final AccountEntity result = await _repository.save(entity);

    _adAccess.consumeUse();

    return result;
  }

  @override
  Future<AccountEntity> changeInitialAmount({required AccountEntity entity, required double readjustmentValue}) async {
    if (readjustmentValue == 0) throw ValidationException(R.strings.greaterThanZero);

    entity.initialAmount = (entity.initialAmount + readjustmentValue).toRound(2);

    return await save(entity);
  }
}
