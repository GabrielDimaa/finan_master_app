import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class AuthEntity extends Entity {
  String email;
  bool emailVerified;
  String? password;
  AuthType type;

  AuthEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.email,
    required this.emailVerified,
    required this.password,
    required this.type,
  });
}
