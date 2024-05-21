import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';
import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_signup_auth.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class SignupAuth implements ISignupAuth {
  final IAuthRepository _repository;

  SignupAuth({required IAuthRepository repository}) : _repository = repository;

  @override
  Future<void> signup(SignupEntity entity) async {
    if (entity.auth.type == AuthType.email) {
      entity.auth.email = entity.userAccount.email;

      if (entity.userAccount.name.trim().isEmpty) throw ValidationException(R.strings.uninformedName);
      if (entity.userAccount.email.trim().isEmpty || entity.auth.email.trim().isEmpty) throw ValidationException(R.strings.uninformedEmail);
      if (entity.auth.password == null || entity.auth.password!.trim().isEmpty) throw ValidationException(R.strings.uninformedPassword);

      final bool emailAlreadyExists = await _repository.emailAlreadyExists(entity.userAccount.email.trim());
      if (emailAlreadyExists) throw ValidationException(R.strings.emailInUse);

      await _repository.signupWithEmailAndPassword(entity);
    }

    if (entity.auth.type == AuthType.google) {
      await _repository.signupWithGoogle() ?? (throw OperationCanceledException());
    }
  }

  @override
  Future<bool> emailAlreadyExists(String email) => _repository.emailAlreadyExists(email);

  @override
  Future<void> sendEmailVerification() => _repository.sendEmailVerification();

  @override
  Future<bool> checkEmailVerified() => _repository.checkEmailVerified();

  @override
  Future<void> completeRegistration() async {
    final bool isEmailVerified = await checkEmailVerified();

    if (!isEmailVerified) throw ValidationException(R.strings.emailNotVerified);

    await _repository.saveEmailVerified(isEmailVerified);
  }
}
