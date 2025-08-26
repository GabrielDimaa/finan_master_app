import 'package:flutter/material.dart';

abstract interface class IConfigRepository {
  ThemeMode? findThemeMode();

  Future<void> saveThemeMode(ThemeMode themeMode);

  Locale? findLocale();

  Future<void> saveLocale(Locale locale);

  bool? findHideAmounts();

  Future<void> saveHideAmounts(bool hideAmounts);
}
