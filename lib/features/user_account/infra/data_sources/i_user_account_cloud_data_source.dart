import 'package:finan_master_app/features/user_account/infra/models/user_account_model.dart';

abstract interface class IUserAccountCloudDataSource {
  Future<UserAccountModel> insert(UserAccountModel model);

  Future<UserAccountModel> update(UserAccountModel model);

  Future<UserAccountModel?> getByEmail(String email);
}
