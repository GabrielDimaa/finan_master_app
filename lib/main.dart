import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/shared/presentation/ui/app.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    DependencyInjection().setup(),
  ]);

  runApp(App());
}
