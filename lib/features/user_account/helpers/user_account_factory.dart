import 'package:finan_master_app/features/user_account/domain/entities/user_account_entity.dart';
import 'package:finan_master_app/features/user_account/infra/models/user_account_model.dart';

abstract class UserAccountFactory {
  static UserAccountModel fromEntity(UserAccountEntity entity) {
    return UserAccountModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      name: entity.name,
      email: entity.email,
    );
  }

  static UserAccountEntity toEntity(UserAccountModel model) {
    return UserAccountEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      name: model.name,
      email: model.email,
    );
  }
}
