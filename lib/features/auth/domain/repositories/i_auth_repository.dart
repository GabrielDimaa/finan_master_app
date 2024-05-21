import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';

abstract interface class IAuthRepository {
  Future<AuthEntity> loginWithEmailAndPassword(AuthEntity entity);

  Future<AuthEntity?> loginWithGoogle(AuthEntity entity);

  Future<SignupEntity> signupWithEmailAndPassword(SignupEntity entity);

  Future<SignupEntity?> signupWithGoogle();

  Future<AuthEntity?> find();

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();

  Future<bool> existsEmail(String email);

  Future<void> saveEmailVerified(bool isEmailVerified);
}
