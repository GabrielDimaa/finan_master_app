import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/i_auth_driver.dart';

class AuthRepository implements IAuthRepository {
  final IAuthDriver _authDriver;

  AuthRepository({required IAuthDriver authDriver}) : _authDriver = authDriver;

  @override
  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    await _authDriver.loginWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }
}