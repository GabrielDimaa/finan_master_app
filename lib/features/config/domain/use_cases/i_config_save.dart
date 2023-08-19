import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

abstract interface class IConfigSave {
  Future<Result<ThemeMode, BaseException>> saveThemeMode(ThemeMode themeMode);

  Future<Result<Locale, BaseException>> saveLocale(Locale locale);
}
