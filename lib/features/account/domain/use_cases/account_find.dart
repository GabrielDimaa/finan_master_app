import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

class AccountFind implements IAccountFind {
  final IAccountRepository _repository;

  AccountFind({required IAccountRepository repository}) : _repository = repository;

  @override
  Future<Result<List<AccountEntity>, BaseException>> findAll() => _repository.findAll();
}
