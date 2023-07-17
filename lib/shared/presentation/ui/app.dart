import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:flutter/material.dart';

const String appName = "Finan Master";

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final RouterConfig<Object> routerConfig = AppRouter.routerConfig();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appName,
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Roboto",
        colorScheme: themeDark,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(padding: const EdgeInsets.all(20)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(20),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  ColorScheme get themeLight => ColorScheme.fromSeed(seedColor: const Color(0xFF005BC0), brightness: Brightness.light);

  ColorScheme get themeDark => ColorScheme.fromSeed(seedColor: const Color(0xFF005BC0), brightness: Brightness.dark);
}
