import 'dart:async';

import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/splash/presentation/ui/initial_splash_page.dart';
import 'package:finan_master_app/shared/infra/drivers/ad/i_ad_driver.dart';
import 'package:finan_master_app/shared/presentation/ui/app.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const InitialSplashPage());

  unawaited(MobileAds.instance.initialize());

  await Future.wait([
    AppLocale().load(),
    DependencyInjection().setup(),
  ]);

  DI.get<IAdDriver>().loadInterstitialAd();

  runApp(const App());
}

void reset() async {
  await DependencyInjection().dispose();

  main();
}
