import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_login_auth.dart';
import 'package:finan_master_app/features/auth/helpers/factories/auth_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  final ILoginAuth _loginAuth;

  late final Command0 loginWithEmailAndPassword;
  late final Command0 loginWithGoogle;

  LoginViewModel({required ILoginAuth loginAuth}) : _loginAuth = loginAuth {
    loginWithEmailAndPassword = Command0(_loginWithEmailAndPassword);
    loginWithGoogle = Command0(_loginWithGoogle);
  }

  bool get isLoading => loginWithEmailAndPassword.running || loginWithGoogle.running;

  final AuthEntity _auth = AuthFactory.withEmail(email: '', password: '');

  AuthEntity get auth => _auth;

  Future<void> _loginWithEmailAndPassword() => _loginAuth.login(auth);

  Future<void> _loginWithGoogle() => _loginAuth.login(AuthFactory.withGoogle(email: ''));
}
