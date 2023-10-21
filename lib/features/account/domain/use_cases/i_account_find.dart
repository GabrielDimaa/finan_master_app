import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';

abstract interface class IAccountFind {
  Future<List<AccountEntity>> findAll({bool deleted = false});

  Future<AccountEntity?> findById(String id);

  Future<double> findBalanceUntilDate(DateTime date);
}
