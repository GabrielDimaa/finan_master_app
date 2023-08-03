import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/infra/data_sources/account_data_source.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_data_source.dart';
import 'package:finan_master_app/features/account/infra/repositories/account_repository.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/usecases/category_delete.dart';
import 'package:finan_master_app/features/category/domain/usecases/category_find.dart';
import 'package:finan_master_app/features/category/domain/usecases/category_save.dart';
import 'package:finan_master_app/features/category/domain/usecases/i_category_delete.dart';
import 'package:finan_master_app/features/category/domain/usecases/i_category_find.dart';
import 'package:finan_master_app/features/category/domain/usecases/i_category_save.dart';
import 'package:finan_master_app/features/category/infra/data_sources/category_data_source.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_data_source.dart';
import 'package:finan_master_app/features/category/infra/repositories/category_repository.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/category_notifier.dart';
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
    getIt.registerFactory<IAccountDataSource>(() => AccountDataSource(databaseLocal: databaseLocal));

    //Repositories
    getIt.registerFactory<ICategoryRepository>(() => CategoryRepository(dataSource: getIt.get<ICategoryDataSource>()));
    getIt.registerFactory<IAccountRepository>(() => AccountRepository(dataSource: getIt.get<IAccountDataSource>()));

    //Usecases
    getIt.registerFactory<ICategoryFind>(() => CategoryFind(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategorySave>(() => CategorySave(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategoryDelete>(() => CategoryDelete(repository: getIt.get<ICategoryRepository>()));

    //Controllers
    getIt.registerFactory<CategoriesNotifier>(() => CategoriesNotifier(categoryFind: getIt.get<ICategoryFind>()));
    getIt.registerFactory<CategoryNotifier>(() => CategoryNotifier(categorySave: getIt.get<ICategorySave>(), categoryDelete: getIt.get<ICategoryDelete>()));
  }
}
