import 'package:finan_master_app/features/auth/domain/entities/auth_entity.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_auth_find.dart';
import 'package:finan_master_app/features/splash/presentation/states/splash_state.dart';
import 'package:flutter/cupertino.dart';

class SplashNotifier extends ValueNotifier<SplashState> {
  final IAuthFind _authFind;

  SplashNotifier({required IAuthFind authFind})
      : _authFind = authFind,
        super(SplashState.start());

  AuthEntity? auth;

  Future<void> init() async {
    try {
      auth = await _authFind.find();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
