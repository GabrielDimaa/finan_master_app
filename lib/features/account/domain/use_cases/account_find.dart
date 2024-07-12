import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';

class AccountFind implements IAccountFind {
  final IAccountRepository _repository;

  AccountFind({required IAccountRepository repository}) : _repository = repository;

  @override
  Future<List<AccountEntity>> findAll({bool deleted = false}) => _repository.findAll(deleted: deleted);

  @override
  Future<AccountEntity?> findById(String id) => _repository.findById(id);

  @override
  Future<double> findBalanceUntilDate(DateTime date) => _repository.findBalanceUntilDate(date);

  @override
  Future<double> findAccountsBalance() => _repository.findAccountsBalance();
}
