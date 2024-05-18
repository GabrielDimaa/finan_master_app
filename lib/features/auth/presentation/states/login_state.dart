import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/helpers/factories/auth_factory.dart';

sealed class LoginState {
  final AuthEntity entity;

  const LoginState({required this.entity});

  factory LoginState.start() => StartLoginState();

  LoginState setChanged(AuthEntity value) => ChangedLoginState(entity: value);

  LoginState setLoggingWithEmailAndPassword() => LoggingWithEmailAndPasswordState(entity: entity);

  LoginState setLoggingWithGoogle() => LoggingWithGoogleState(entity: entity);

  LoginState setError(String message) => ErrorLoginState(message, entity: entity);
}

class StartLoginState extends LoginState {
  StartLoginState() : super(entity: AuthFactory.withEmail(email: '', password: ''));
}

class ChangedLoginState extends LoginState {
  const ChangedLoginState({required super.entity});
}

class LoggingWithEmailAndPasswordState extends LoginState {
  const LoggingWithEmailAndPasswordState({required super.entity});
}

class LoggingWithGoogleState extends LoginState {
  const LoggingWithGoogleState({required super.entity});
}

class ErrorLoginState extends LoginState {
  final String message;

  ErrorLoginState(this.message, {required super.entity});
}
