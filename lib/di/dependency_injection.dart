import 'package:finan_master_app/infra/data_sources/database_local/database_local.dart';
import 'package:finan_master_app/infra/data_sources/database_local/i_database_local.dart';
import 'package:get_it/get_it.dart';

final class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._();

  DependencyInjection._();

  factory DependencyInjection() => _instance;

  Future<void> setup() async {
    final GetIt getIt = GetIt.instance;

    //Data Sources
    final DatabaseLocal databaseLocal = await DatabaseLocal.getInstance();

    getIt.registerSingleton<IDatabaseLocal>(databaseLocal);
  }
}
