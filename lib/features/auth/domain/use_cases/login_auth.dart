import 'package:finan_master_app/features/auth/domain/entities/login_entity.dart';
import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_login_auth.dart';
import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class LoginAuth implements ILoginAuth {
  final IAuthRepository _repository;

  LoginAuth({required IAuthRepository repository}) : _repository = repository;

  @override
  Future<void> loginWithEmailAndPassword(LoginEntity entity) async {
    if (entity.email == null || entity.email!.trim().isEmpty) throw ValidationException(R.strings.uninformedEmail);
    if (entity.password == null || entity.password!.trim().isEmpty) throw ValidationException(R.strings.uninformedPassword);
    
    await _repository.loginWithEmailAndPassword(email: entity.email!, password: entity.password!);
  }

  @override
  Future<void> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }
}
