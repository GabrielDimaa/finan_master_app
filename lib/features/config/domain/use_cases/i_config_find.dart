import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

abstract interface class IConfigFind {
  Result<ThemeMode, BaseException> findThemeMode();
  Result<Locale, BaseException> findLocale();
}
