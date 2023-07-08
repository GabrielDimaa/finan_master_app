import 'package:finan_master_app/di/dependency_injection.dart';

void main() async {
  await Future.wait([
    DependencyInjection().setup(),
  ]);
}
