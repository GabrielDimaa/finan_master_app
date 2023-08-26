import 'dart:io';

import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:flutter/material.dart';

class ConfigFind implements IConfigFind {
  final IConfigRepository _repository;

  ConfigFind({required IConfigRepository repository}) : _repository = repository;

  @override
  ThemeMode findThemeMode() {
    final ThemeMode? themeMode = _repository.findThemeMode();

    return themeMode ?? ThemeMode.dark;
  }

  @override
  Locale findLocale() {
    final Locale? locale = _repository.findLocale();

    return locale ?? Locale(Platform.localeName.split('_').first);
  }
}
