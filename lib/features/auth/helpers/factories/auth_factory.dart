import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';

abstract class AuthFactory {
  static AuthModel fromEntity(AuthEntity entity) {
    return AuthModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      email: entity.email,
      emailVerified: entity.emailVerified,
      password: entity.password,
      type: entity.type,
    );
  }

  static AuthEntity toEntity(AuthModel model) {
    return AuthEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      email: model.email,
      emailVerified: model.emailVerified,
      password: model.password,
      type: model.type,
    );
  }

  static AuthEntity withEmail({required String email, required String password}) {
    return AuthEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      email: email,
      emailVerified: false,
      password: password,
      type: AuthType.email,
    );
  }

  static AuthEntity withGoogle({String email = ''}) {
    return AuthEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      email: email,
      emailVerified: true,
      password: null,
      type: AuthType.google,
    );
  }
}
