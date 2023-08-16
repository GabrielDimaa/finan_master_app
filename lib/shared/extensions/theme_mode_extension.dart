import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  int get value => this == ThemeMode.dark ? 0 : 1;

  static ThemeMode getByValue(int value) => value == 0 ? ThemeMode.dark : ThemeMode.light;
}
