import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

abstract interface class IAccountSave {
  Future<Result<AccountEntity, BaseException>> save(AccountEntity entity);

  Future<Result<AccountEntity, BaseException>> readjustBalance(AccountEntity entity, readjustmentValue);
}
