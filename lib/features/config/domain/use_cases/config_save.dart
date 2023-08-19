import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

class ConfigSave implements IConfigSave {
  final IConfigRepository _repository;

  ConfigSave({required IConfigRepository repository}) : _repository = repository;

  @override
  Future<Result<ThemeMode, BaseException>> saveThemeMode(ThemeMode themeMode) => _repository.saveThemeMode(themeMode);

  @override
  Future<Result<Locale, BaseException>> saveLocale(Locale locale) => _repository.saveLocale(locale);
}
