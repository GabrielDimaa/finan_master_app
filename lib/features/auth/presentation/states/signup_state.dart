import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';
import 'package:finan_master_app/features/auth/helpers/factories/auth_factory.dart';
import 'package:finan_master_app/features/user_account/domain/entities/user_account_entity.dart';

sealed class SignupState {
  final SignupEntity entity;

  const SignupState({required this.entity});

  factory SignupState.start() => StartSignupState();

  SignupState setChanged(SignupEntity value) => ChangedSignupState(entity: value);

  SignupState setSigningUpWithEmailAndPassword() => SigningUpWithEmailAndPasswordState(entity: entity);

  SignupState setSigningUpWithGoogle() => SigningUpWithGoogleState(entity: entity);

  SignupState setError(String message) => ErrorSignupState(message, entity: entity);
}

class StartSignupState extends SignupState {
  StartSignupState()
      : super(
          entity: SignupEntity(
            auth: AuthFactory.withEmail(email: '', password: ''),
            userAccount: UserAccountEntity(
              id: null,
              createdAt: null,
              deletedAt: null,
              name: '',
              email: '',
            ),
          ),
        );
}

class ChangedSignupState extends SignupState {
  const ChangedSignupState({required super.entity});
}

class SigningUpWithEmailAndPasswordState extends SignupState {
  const SigningUpWithEmailAndPasswordState({required super.entity});
}

class SigningUpWithGoogleState extends SignupState {
  const SigningUpWithGoogleState({required super.entity});
}

class ErrorSignupState extends SignupState {
  final String message;

  ErrorSignupState(this.message, {required super.entity});
}
