import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/splash/presentation/ui/initial_splash_page.dart';
import 'package:finan_master_app/shared/presentation/ui/app.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const InitialSplashPage());

  await Future.wait([
    AppLocale().load(),
    DependencyInjection().setup(),
  ]);

  runApp(const App());
}
