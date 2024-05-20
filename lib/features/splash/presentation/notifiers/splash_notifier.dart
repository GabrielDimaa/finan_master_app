import 'package:finan_master_app/features/auth/domain/use_cases/i_auth_find.dart';
import 'package:finan_master_app/features/splash/presentation/states/splash_state.dart';
import 'package:flutter/cupertino.dart';

class SplashNotifier extends ValueNotifier<SplashState> {
  final IAuthFind _authFind;

  SplashNotifier({required IAuthFind authFind})
      : _authFind = authFind,
        super(SplashState.start());

  bool userIsLogged = false;

  Future<void> init() async {
    try {
      userIsLogged = await _authFind.checkIsLogged();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
