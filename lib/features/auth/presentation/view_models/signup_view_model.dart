import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_signup_auth.dart';
import 'package:finan_master_app/features/auth/helpers/factories/auth_factory.dart';
import 'package:finan_master_app/features/auth/helpers/factories/signup_factory.dart';
import 'package:finan_master_app/features/user_account/domain/entities/user_account_entity.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class SignupViewModel extends ChangeNotifier {
  final ISignupAuth _signupAuth;

  late final Command0 signupWithEmailAndPassword;
  late final Command0 signupWithGoogle;

  SignupViewModel({required ISignupAuth signupAuth}) : _signupAuth = signupAuth {
    signupWithEmailAndPassword = Command0(_signupWithEmailAndPassword);
    signupWithGoogle = Command0(_signupWithGoogle);
  }

  bool get isLoading => signupWithEmailAndPassword.running || signupWithGoogle.running;

  final SignupEntity _signup = SignupFactory.newEntity();

  SignupEntity get signup => _signup;

  Future<void> _signupWithEmailAndPassword() => _signupAuth.signup(signup);

  Future<void> _signupWithGoogle() => _signupAuth.signup(SignupEntity(auth: AuthFactory.withGoogle(), userAccount: UserAccountEntity(id: null, createdAt: null, deletedAt: null, name: '', email: '')));
}
