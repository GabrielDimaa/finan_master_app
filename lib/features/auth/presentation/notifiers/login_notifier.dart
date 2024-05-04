import 'package:finan_master_app/features/auth/domain/use_cases/i_login_auth.dart';
import 'package:finan_master_app/features/auth/helpers/auth_factory.dart';
import 'package:finan_master_app/features/auth/presentation/states/login_state.dart';
import 'package:flutter/cupertino.dart';

class LoginNotifier extends ValueNotifier<LoginState> {
  final ILoginAuth _loginAuth;

  LoginNotifier({required ILoginAuth loginAuth})
      : _loginAuth = loginAuth,
        super(LoginState.start());

  bool get isLoading => value is LoggingWithEmailAndPasswordState || value is LoggingWithGoogleState;

  Future<void> login() async {
    try {
      value = value.setLoggingWithEmailAndPassword();

      await _loginAuth.login(value.entity);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      value = value.setLoggingWithGoogle();

      await _loginAuth.login(AuthFactory.withGoogle(email: ''));
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
