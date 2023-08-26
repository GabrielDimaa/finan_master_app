import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:flutter/material.dart';

class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  final IConfigFind _configFind;
  final IConfigSave _configSave;

  ThemeModeNotifier({required IConfigFind configFind, required IConfigSave configSave})
      : _configFind = configFind,
        _configSave = configSave,
        super(ThemeMode.dark) {
    find();
  }

  void find() => value = _configFind.findThemeMode();

  void changeAndSave(ThemeMode themeMode) {
    value = themeMode;
    save(themeMode);
  }

  Future<void> save(ThemeMode themeMode) => _configSave.saveThemeMode(themeMode);
}
