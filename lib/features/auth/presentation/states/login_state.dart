import 'package:finan_master_app/features/auth/domain/entities/login_entity.dart';

sealed class LoginState {
  final LoginEntity loginEntity;

  const LoginState({required this.loginEntity});

  factory LoginState.start() => StartLoginState();

  LoginState setLogging() => LoggingState(loginEntity: loginEntity);

  LoginState setError(String message) => ErrorLoginState(message, loginEntity: loginEntity);
}

class StartLoginState extends LoginState {
  StartLoginState() : super(loginEntity: LoginEntity(email: null, password: null));
}

class LoggingState extends LoginState {
  const LoggingState({required super.loginEntity});
}

class ErrorLoginState extends LoginState {
  final String message;

  ErrorLoginState(this.message, {required super.loginEntity});
}
