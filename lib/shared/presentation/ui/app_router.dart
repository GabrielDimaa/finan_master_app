import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/presentation/ui/categories_page.dart';
import 'package:finan_master_app/features/category/presentation/ui/category_page.dart';
import 'package:finan_master_app/features/config/presentation/ui/config_page.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/features/splash/presentation/ui/splash_page.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_bar_rail.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

sealed class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
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
          name: CategoryPage.route,
          path: '/${CategoryPage.route}',
          builder: (_, GoRouterState state) => CategoryPage(category: state.extra as CategoryEntity?),
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
                  name: CategoriesPage.route,
                  path: '/${CategoriesPage.route}',
                  builder: (_, __) => const CategoriesPage(),
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