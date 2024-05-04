import 'package:finan_master_app/features/auth/infra/models/auth_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/i_local_data_source.dart';

abstract interface class IAuthLocalDataSource implements ILocalDataSource<AuthModel> {
  Future<void> deleteAll();
}
