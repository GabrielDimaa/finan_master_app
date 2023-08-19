import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/extensions/theme_mode_extension.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:flutter/material.dart';

class ConfigRepository implements IConfigRepository {
  final ICacheLocal _cacheLocal;

  ConfigRepository({required ICacheLocal cacheLocal}) : _cacheLocal = cacheLocal;

  static const String themeModeKey = "theme_mode";
  static const String localeKey = "locale";

  @override
  Result<ThemeMode?, BaseException> findThemeMode() {
    final int? themeMode = _cacheLocal.get<int>(themeModeKey);

    if (themeMode == null) return Result.success(null);

    return Result.success(ThemeModeExtension.getByValue(themeMode));
  }

  @override
  Future<Result<ThemeMode, BaseException>> saveThemeMode(ThemeMode themeMode) async {
    await _cacheLocal.save(themeModeKey, themeMode.value);
    return Result.success(themeMode);
  }

  @override
  Result<Locale?, BaseException> findLocale() {
    final String? locale = _cacheLocal.get<String>(localeKey);

    if (locale == null) return Result.success(null);

    return Result.success(Locale(locale));
  }

  @override
  Future<Result<Locale, BaseException>> saveLocale(Locale locale) async {
    await _cacheLocal.save(localeKey, locale.languageCode);
    return Result.success(locale);
  }
}
