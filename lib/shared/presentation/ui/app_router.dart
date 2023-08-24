import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_details_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/accounts_list_page.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/presentation/ui/categories_list_page.dart';
import 'package:finan_master_app/features/category/presentation/ui/category_form_page.dart';
import 'package:finan_master_app/features/config/presentation/ui/config_page.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/features/splash/presentation/ui/splash_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transactions_list_page.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_bar_rail.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

sealed class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _transactionsNavigatorKey = GlobalKey<NavigatorState>();
  static final _configNavigatorKey = GlobalKey<NavigatorState>();

  static RouterConfig<Object> routerConfig() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey, //https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
      initialLocation: '/${HomePage.route}',
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: SplashPage.route,
          path: '/${SplashPage.route}',
          builder: (_, __) => const SplashPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: CategoryFormPage.route,
          path: '/${CategoryFormPage.route}',
          builder: (_, GoRouterState state) => CategoryFormPage(category: state.extra as CategoryEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: AccountFormPage.route,
          path: '/${AccountFormPage.route}',
          builder: (_, GoRouterState state) => AccountFormPage(account: state.extra as AccountEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: AccountDetailsPage.route,
          path: '/${AccountDetailsPage.route}',
          builder: (_, GoRouterState state) => AccountDetailsPage(account: state.extra as AccountEntity),
        ),
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __, navigationShell) => NavBarRail(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _homeNavigatorKey,
                  name: HomePage.route,
                  path: '/${HomePage.route}',
                  builder: (_, __) => const HomePage(),
                ),
                GoRoute(
                  parentNavigatorKey: _homeNavigatorKey,
                  name: CategoriesListPage.route,
                  path: '/${CategoriesListPage.route}',
                  builder: (_, __) => const CategoriesListPage(),
                ),
                GoRoute(
                  parentNavigatorKey: _homeNavigatorKey,
                  name: AccountsListPage.route,
                  path: '/${AccountsListPage.route}',
                  builder: (_, __) => const AccountsListPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _transactionsNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _transactionsNavigatorKey,
                  name: TransactionsListPage.route,
                  path: '/${TransactionsListPage.route}',
                  builder: (_, __) => const TransactionsListPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _configNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _configNavigatorKey,
                  name: ConfigPage.route,
                  path: '/${ConfigPage.route}',
                  builder: (_, __) => const ConfigPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}