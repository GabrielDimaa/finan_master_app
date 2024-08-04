import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/locale_notifier.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/theme_mode_notifier.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String appName = 'Finan Master';
const Color primaryColor = Color(0xFF005BC0);

class App extends StatefulWidget {
  const App({super.key});

  static final ThemeModeNotifier themeNotifier = DI.get<ThemeModeNotifier>();
  static final LocaleNotifier localeNotifier = DI.get<LocaleNotifier>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final RouterConfig<Object> routerConfig = AppRouter.routerConfig();

  @override
  void initState() {
    super.initState();

    App.themeNotifier.find();
    App.localeNotifier.find();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([App.localeNotifier, App.themeNotifier]),
      builder: (_, __) {
        return MaterialApp.router(
          title: appName,
          debugShowCheckedModeBanner: false,
          routerConfig: routerConfig,
          themeMode: App.themeNotifier.value,
          theme: ThemeData(
            fontFamily: 'Roboto',
            colorScheme: App.themeNotifier.value == ThemeMode.dark ? themeDark : themeLight,
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            segmentedButtonTheme: const SegmentedButtonThemeData(
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll<Size>(Size.fromHeight(40)),
                padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 12)),
              ),
            ),
            dividerTheme: const DividerThemeData(
              space: 2,
            ),
            listTileTheme: const ListTileThemeData(
              contentPadding: EdgeInsets.only(left: 16, top: 8, right: 24, bottom: 8),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(16),
            ),
            appBarTheme: const AppBarTheme(
              scrolledUnderElevation: 0,
            ),
            cardTheme: const CardTheme(
              elevation: 0,
              margin: EdgeInsets.zero,
            ),
          ),
          locale: App.localeNotifier.value,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }

  ColorScheme get themeLight => ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.light);

  ColorScheme get themeDark => ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.dark);
}
