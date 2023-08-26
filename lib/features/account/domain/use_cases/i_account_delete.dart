import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';

abstract interface class IAccountDelete {
  Future<void> delete(AccountEntity entity);
}
