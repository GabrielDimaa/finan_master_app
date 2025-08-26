import 'package:flutter/material.dart';

abstract interface class IConfigFind {
  ThemeMode findThemeMode();

  Locale findLocale();

  bool findHideAmounts();
}
