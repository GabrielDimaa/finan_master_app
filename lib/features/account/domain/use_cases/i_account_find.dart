import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

abstract interface class IAccountFind {
  Future<Result<List<AccountEntity>, BaseException>> findAll();
}
