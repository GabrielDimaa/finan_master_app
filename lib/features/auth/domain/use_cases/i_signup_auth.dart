import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';

abstract interface class ISignupAuth {
  Future<void> signup(SignupEntity entity);
}