import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/entities/signup_entity.dart';
import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/helpers/factories/auth_factory.dart';
import 'package:finan_master_app/features/auth/infra/data_sources/i_auth_local_data_source.dart';
import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';
import 'package:finan_master_app/features/auth/infra/models/signup_model.dart';
import 'package:finan_master_app/features/user_account/helpers/user_account_factory.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/i_user_account_cloud_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/i_user_account_local_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/models/user_account_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/i_auth_driver.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDataSource;
  final IUserAccountLocalDataSource _userAccountLocalDataSource;
  final IUserAccountCloudDataSource _userAccountCloudDataSource;
  final IAuthDriver _authDriver;
  final IDatabaseLocalTransaction _databaseLocalTransaction;

  AuthRepository({
    required IAuthLocalDataSource authDataSource,
    required IUserAccountLocalDataSource userAccountLocalDataSource,
    required IUserAccountCloudDataSource userAccountCloudDataSource,
    required IAuthDriver authDriver,
    required IDatabaseLocalTransaction databaseLocalTransaction,
  })  : _authDataSource = authDataSource,
        _userAccountLocalDataSource = userAccountLocalDataSource,
        _userAccountCloudDataSource = userAccountCloudDataSource,
        _authDriver = authDriver,
        _databaseLocalTransaction = databaseLocalTransaction;

  @override
  Future<AuthEntity> loginWithEmailAndPassword(AuthEntity entity) async {
    await _authDataSource.deleteAll();
    await _userAccountLocalDataSource.deleteAll();

    final AuthModel model = AuthFactory.fromEntity(entity);

    await _authDriver.loginWithEmailAndPassword(email: model.email, password: model.password!);

    final UserAccountModel userAccountModel = await _userAccountCloudDataSource.getByEmail(model.email) ?? (throw Exception(R.strings.userNotFound));

    await _saveAuthAndUserAccount(model: model, userAccount: userAccountModel);

    return AuthFactory.toEntity(model);
  }

  @override
  Future<AuthEntity?> loginWithGoogle(AuthEntity entity) async {
    final AuthModel? model = await _authDriver.loginWithGoogle();
    if (model == null) return null;

    final UserAccountModel userAccountModel = await _userAccountCloudDataSource.getByEmail(model.email) ?? (throw Exception(R.strings.userNotFound));

    await _saveAuthAndUserAccount(model: model, userAccount: userAccountModel);

    return AuthFactory.toEntity(model);
  }

  @override
  Future<SignupEntity> signupWithEmailAndPassword(SignupEntity entity) async {
    AuthModel model = AuthFactory.fromEntity(entity.auth);
    UserAccountModel userAccountModel = UserAccountFactory.fromEntity(entity.userAccount);

    await _authDriver.signupWithEmailAndPassword(email: model.email, password: model.password!);

    userAccountModel = await _userAccountCloudDataSource.insert(userAccountModel);

    _saveAuthAndUserAccount(model: model, userAccount: userAccountModel);

    return SignupEntity(
      auth: AuthFactory.toEntity(model),
      userAccount: UserAccountFactory.toEntity(userAccountModel),
    );
  }

  @override
  Future<SignupEntity?> signupWithGoogle() async {
    final SignupModel? model = await _authDriver.signupWithGoogle();
    if (model == null) return null;

    model.userAccount = await _userAccountCloudDataSource.insert(model.userAccount);

    await _saveAuthAndUserAccount(model: model.auth, userAccount: model.userAccount);

    return SignupEntity(
      auth: AuthFactory.toEntity(model.auth),
      userAccount: UserAccountFactory.toEntity(model.userAccount),
    );
  }

  Future<void> _saveAuthAndUserAccount({required AuthModel model, required UserAccountModel userAccount}) async {
    await _authDataSource.deleteAll();
    await _userAccountLocalDataSource.deleteAll();

    await _databaseLocalTransaction.openTransaction((txn) async {
      await Future.wait([
        _authDataSource.insert(model, txn: txn),
        _userAccountLocalDataSource.insert(userAccount, txn: txn),
      ]);
    });
  }

  @override
  Future<bool> checkIsLogged() async {
    final bool isLogged = await _authDriver.checkIsLogged();
    final AuthModel? model = await _authDataSource.findOne();

    return isLogged && model != null;
  }
}
