import 'package:flutter/material.dart';

abstract interface class IConfigSave {
  Future<void> saveThemeMode(ThemeMode themeMode);

  Future<void> saveLocale(Locale locale);

  Future<void> saveHideAmounts(bool hideAmounts);
}
