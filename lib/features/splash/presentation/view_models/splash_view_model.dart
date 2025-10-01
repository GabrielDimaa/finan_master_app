import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_auth_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class SplashViewModel extends ChangeNotifier {
  late final Command0<AuthEntity?> authFind;

  SplashViewModel({required IAuthFind authFind}) {
    this.authFind = Command0(authFind.find);
  }
}
