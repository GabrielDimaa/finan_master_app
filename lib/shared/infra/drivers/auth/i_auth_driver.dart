import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';
import 'package:finan_master_app/features/auth/infra/models/signup_model.dart';

abstract class IAuthDriver {
  Future<void> signupWithEmailAndPassword({required String email, required String password});

  Future<SignupModel?> signupWithGoogle();

  Future<void> loginWithEmailAndPassword({required String email, required String password});

  Future<AuthModel?> loginWithGoogle();

  Future<void> sendVerificationEmail(String userId);

  Future<bool> checkEmailVerified(String userId);
}
