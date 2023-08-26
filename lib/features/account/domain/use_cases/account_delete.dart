import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';

class AccountDelete implements IAccountDelete {
  final IAccountRepository _repository;

  AccountDelete({required IAccountRepository repository}) : _repository = repository;

  @override
  Future<void> delete(AccountEntity entity) => _repository.delete(entity);
}
