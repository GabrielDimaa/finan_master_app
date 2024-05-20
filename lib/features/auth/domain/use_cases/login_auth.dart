import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/enums/auth_type.dart';
import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_login_auth.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class LoginAuth implements ILoginAuth {
  final IAuthRepository _repository;

  LoginAuth({required IAuthRepository repository}) : _repository = repository;

  @override
  Future<void> login(AuthEntity entity) async {
    if (entity.type == AuthType.email) {
      if (entity.email.trim().isEmpty) throw ValidationException(R.strings.uninformedEmail);
      if (entity.password == null || entity.password!.trim().isEmpty) throw ValidationException(R.strings.uninformedPassword);

      await _repository.loginWithEmailAndPassword(entity);
    }

    if (entity.type == AuthType.google) {
      final AuthEntity? auth = await _repository.loginWithGoogle(entity);
      if (auth == null) throw OperationCanceledException();
    }
  }
}
