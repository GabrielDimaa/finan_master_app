import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:flutter/material.dart';

class ConfigSave implements IConfigSave {
  final IConfigRepository _repository;

  ConfigSave({required IConfigRepository repository}) : _repository = repository;

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) => _repository.saveThemeMode(themeMode);

  @override
  Future<void> saveLocale(Locale locale) => _repository.saveLocale(locale);

  @override
  Future<void> saveHideAmounts(bool hideAmounts) => _repository.saveHideAmounts(hideAmounts);
}
