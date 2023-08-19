import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

abstract interface class IConfigRepository {
  Result<ThemeMode?, BaseException> findThemeMode();

  Future<Result<ThemeMode, BaseException>> saveThemeMode(ThemeMode themeMode);

  Result<Locale?, BaseException> findLocale();

  Future<Result<Locale, BaseException>> saveLocale(Locale locale);
}
