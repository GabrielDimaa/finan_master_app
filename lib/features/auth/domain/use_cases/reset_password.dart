import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_reset_password.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class ResetPassword implements IResetPassword {
  final IAuthRepository _repository;

  ResetPassword({required IAuthRepository repository}) : _repository = repository;

  @override
  Future<void> send(String email) async {
    final bool exists = await _repository.emailAlreadyExists(email);
    if (!exists) throw Exception(R.strings.userNotFound);

    await _repository.sendEmailResetPassword(email);
  }
}
