import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/helpers/auth_factory.dart';
import 'package:finan_master_app/features/auth/infra/data_sources/i_auth_local_data_source.dart';
import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/i_auth_driver.dart';

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _dataSource;
  final IAuthDriver _authDriver;

  AuthRepository({required IAuthLocalDataSource dataSource, required IAuthDriver authDriver})
      : _dataSource = dataSource,
        _authDriver = authDriver;

  @override
  Future<void> loginWithEmailAndPassword(AuthEntity entity) async {
    AuthModel model = AuthFactory.fromEntity(entity);

    await _dataSource.deleteAll();

    await _authDriver.loginWithEmailAndPassword(email: model.email, password: model.password!);

    model = await _dataSource.insert(model);
  }

  @override
  Future<void> loginWithGoogle(AuthEntity entity) async {
    await _dataSource.deleteAll();

    final String? email = await _authDriver.loginWithGoogle();
    if (email == null) return;

    AuthModel model = AuthFactory.fromEntity(entity..email = email);
    model = await _dataSource.insert(model);
  }
}
