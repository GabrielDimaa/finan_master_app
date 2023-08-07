import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

class AccountDelete implements IAccountDelete {
  final IAccountRepository _repository;

  AccountDelete({required IAccountRepository repository}) : _repository = repository;

  @override
  Future<Result<dynamic, BaseException>> delete(AccountEntity entity) => _repository.delete(entity);
}
