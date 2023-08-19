import 'dart:io';

import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

class ConfigFind implements IConfigFind {
  final IConfigRepository _repository;

  ConfigFind({required IConfigRepository repository}) : _repository = repository;

  @override
  Result<ThemeMode, BaseException> findThemeMode() {
    final result = _repository.findThemeMode();

    if (result.isError()) return Result.failure(result.failureOrNull()!);

    return Result.success(result.successOrNull() ?? ThemeMode.dark);
  }

  @override
  Result<Locale, BaseException> findLocale() {
    final result = _repository.findLocale();

    if (result.isError()) return Result.failure(result.failureOrNull()!);

    return Result.success(result.successOrNull() ?? Locale(Platform.localeName.split('_').first));
  }
}
