import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_find.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_save.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/account/infra/data_sources/account_data_source.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_data_source.dart';
import 'package:finan_master_app/features/account/infra/repositories/account_repository.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/account_notifier.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/use_cases/category_delete.dart';
import 'package:finan_master_app/features/category/domain/use_cases/category_find.dart';
import 'package:finan_master_app/features/category/domain/use_cases/category_save.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_delete.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_save.dart';
import 'package:finan_master_app/features/category/infra/data_sources/category_data_source.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_data_source.dart';
import 'package:finan_master_app/features/category/infra/repositories/category_repository.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/category_notifier.dart';
import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/features/config/domain/use_cases/config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/config_save.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:finan_master_app/features/config/infra/repositories/config_repository.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/locale_notifier.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/theme_mode_notifier.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._();

  DependencyInjection._();

  factory DependencyInjection() => _instance;

  Future<void> setup() async {
    final GetIt getIt = GetIt.instance;

    //Data Sources
    final DatabaseLocal databaseLocal = await DatabaseLocal.getInstance();
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    getIt.registerSingleton<IDatabaseLocal>(databaseLocal);
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerFactory<ICacheLocal>(() => CacheLocal(sharedPreferences: sharedPreferences));

    getIt.registerFactory<ICategoryDataSource>(() => CategoryDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<IAccountDataSource>(() => AccountDataSource(databaseLocal: databaseLocal));

    //Repositories
    getIt.registerFactory<ICategoryRepository>(() => CategoryRepository(dataSource: getIt.get<ICategoryDataSource>()));
    getIt.registerFactory<IAccountRepository>(() => AccountRepository(dataSource: getIt.get<IAccountDataSource>()));
    getIt.registerFactory<IConfigRepository>(() => ConfigRepository(cacheLocal: getIt.get<ICacheLocal>()));

    //Usecases
    getIt.registerFactory<ICategoryFind>(() => CategoryFind(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategorySave>(() => CategorySave(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategoryDelete>(() => CategoryDelete(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<IAccountFind>(() => AccountFind(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAccountSave>(() => AccountSave(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAccountDelete>(() => AccountDelete(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IConfigFind>(() => ConfigFind(repository: getIt.get<IConfigRepository>()));
    getIt.registerFactory<IConfigSave>(() => ConfigSave(repository: getIt.get<IConfigRepository>()));

    //Controllers
    getIt.registerFactory<CategoriesNotifier>(() => CategoriesNotifier(categoryFind: getIt.get<ICategoryFind>()));
    getIt.registerFactory<CategoryNotifier>(() => CategoryNotifier(categorySave: getIt.get<ICategorySave>(), categoryDelete: getIt.get<ICategoryDelete>()));
    getIt.registerFactory<AccountsNotifier>(() => AccountsNotifier(accountFind: getIt.get<IAccountFind>()));
    getIt.registerFactory<AccountNotifier>(() => AccountNotifier(accountSave: getIt.get<IAccountSave>(), accountDelete: getIt.get<IAccountDelete>()));
    getIt.registerSingleton<ThemeModeNotifier>(ThemeModeNotifier(configFind: getIt.get<IConfigFind>(), configSave: getIt.get<IConfigSave>()));
    getIt.registerSingleton<LocaleNotifier>(LocaleNotifier(configFind: getIt.get<IConfigFind>(), configSave: getIt.get<IConfigSave>()));
  }
}
