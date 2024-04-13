import 'package:finan_master_app/features/auth/domain/entities/login_entity.dart';

abstract interface class ILoginAuth {
  Future<void> loginWithEmailAndPassword(LoginEntity entity);

  Future<void> loginWithGoogle();
}