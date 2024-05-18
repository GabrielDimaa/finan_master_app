import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_signup_auth.dart';
import 'package:finan_master_app/features/auth/helpers/factories/auth_factory.dart';
import 'package:finan_master_app/features/auth/presentation/states/signup_state.dart';
import 'package:finan_master_app/features/user_account/domain/entities/user_account_entity.dart';
import 'package:flutter/cupertino.dart';

class SignupNotifier extends ValueNotifier<SignupState> {
  final ISignupAuth _signupAuth;

  SignupNotifier({required ISignupAuth signupAuth})
      : _signupAuth = signupAuth,
        super(SignupState.start());

  bool get isLoading => value is SigningUpWithEmailAndPasswordState || value is SigningUpWithGoogleState;

  Future<void> signupWithEmailAndPassword() async {
    try {
      value = value.setSigningUpWithEmailAndPassword();

      await _signupAuth.signup(value.entity);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> signupWithGoogle() async {
    try {
      value = value.setSigningUpWithGoogle();

      await _signupAuth.signup(SignupEntity(auth: AuthFactory.withGoogle(), userAccount: UserAccountEntity(id: null, createdAt: null, deletedAt: null, name: '', email: '')));
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
