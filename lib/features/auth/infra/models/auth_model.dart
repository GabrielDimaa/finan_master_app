import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class AuthModel extends Model {
  final String email;
  final bool emailVerified;
  final String? password;
  final AuthType type;

  AuthModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.email,
    required this.emailVerified,
    required this.password,
    required this.type,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'email': email,
      'email_verified': emailVerified,
      'password': password,
      'type': type.value,
    };
  }

  @override
  AuthModel clone() {
    return AuthModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      email: email,
      emailVerified: emailVerified,
      password: password,
      type: type,
    );
  }
}
