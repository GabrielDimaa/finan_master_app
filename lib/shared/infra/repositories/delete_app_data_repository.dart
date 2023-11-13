import 'package:finan_master_app/shared/domain/repositories/i_delete_app_data_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';

class DeleteAppDataRepository implements IDeleteAppDataRepository {
  final IDatabaseLocal _databaseLocal;
  final ICacheLocal _cacheLocal;

  DeleteAppDataRepository({
    required IDatabaseLocal databaseLocal,
    required ICacheLocal cacheLocal,
  })  : _databaseLocal = databaseLocal,
        _cacheLocal = cacheLocal;

  @override
  Future<void> delete() async {
    await Future.wait([
      _databaseLocal.deleteFileDatabase(),
      _cacheLocal.deleteAll(),
    ]);
  }
}
