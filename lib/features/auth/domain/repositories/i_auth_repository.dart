import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<void> loginWithEmailAndPassword(AuthEntity entity);

  Future<void> loginWithGoogle(AuthEntity entity);
}
