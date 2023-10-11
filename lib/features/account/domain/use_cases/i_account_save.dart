import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';

abstract interface class IAccountSave {
  Future<AccountEntity> save(AccountEntity entity);

  Future<AccountEntity> changeInitialAmount({required AccountEntity entity, required double readjustmentValue});
}
