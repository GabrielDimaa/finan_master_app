import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/usecases/category_finds.dart';
import 'package:finan_master_app/features/category/domain/usecases/i_category_finds.dart';
import 'package:finan_master_app/features/category/infra/data_sources/category_data_source.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_data_source.dart';
import 'package:finan_master_app/features/category/infra/repositories/category_repository.dart';
import 'package:finan_master_app/features/category/presentation/controllers/categories_controller.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
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
    getIt.registerFactory<ICategoryDataSource>(() => CategoryDataSource(databaseLocal: databaseLocal));

    //Repositories
    getIt.registerFactory<ICategoryRepository>(() => CategoryRepository(dataSource: getIt.get<ICategoryDataSource>()));

    //Usecases
    getIt.registerFactory<ICategoryFinds>(() => CategoryFinds(repository: getIt.get<ICategoryRepository>()));

    //Controllers
    getIt.registerFactory<CategoriesController>(() => CategoriesController(categoryFinds: getIt.get<ICategoryFinds>()));
  }
}
