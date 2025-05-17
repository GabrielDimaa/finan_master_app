import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';

class AccountDelete implements IAccountDelete {
  final IAccountRepository _repository;
  final IAdAccess _adAccess;

  AccountDelete({required IAccountRepository repository, required IAdAccess adAccess}) : _repository = repository, _adAccess = adAccess;

  @override
  Future<void> delete(AccountEntity entity) => _repository.delete(entity).then((_) => _adAccess.consumeUse());
}
