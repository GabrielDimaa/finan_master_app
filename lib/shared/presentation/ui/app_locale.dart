import 'dart:io';
import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class R {
  static Locale get locale => AppLocale().locale;

  static AppLocalizations get strings => AppLocale().strings;
}

class AppLocale {
  static late AppLocalizations _strings;

  static Locale _locale = Locale(Platform.localeName.split('_').first);

  Locale get locale => _locale;

  AppLocalizations get strings => _strings;

  Future<void> load() async => _strings = await AppLocalizations.delegate.load(locale);

  Future<void> changeLocale(Locale locale) async {
    if (locale == _locale) return;
    _locale = locale;

    await load();
  }
}
