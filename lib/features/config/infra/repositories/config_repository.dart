import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/shared/extensions/theme_mode_extension.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:flutter/material.dart';

class ConfigRepository implements IConfigRepository {
  final ICacheLocal _cacheLocal;

  ConfigRepository({required ICacheLocal cacheLocal}) : _cacheLocal = cacheLocal;

  static const String themeModeKey = "theme_mode";
  static const String localeKey = "locale";
  static const String hideAmountsKey = "hide_amounts";

  @override
  ThemeMode? findThemeMode() {
    final int? themeMode = _cacheLocal.get<int>(themeModeKey);

    if (themeMode == null) return null;

    return ThemeModeExtension.getByValue(themeMode);
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) => _cacheLocal.save(themeModeKey, themeMode.value);

  @override
  Locale? findLocale() {
    final String? locale = _cacheLocal.get<String>(localeKey);

    if (locale == null) return null;

    return Locale(locale);
  }

  @override
  Future<void> saveLocale(Locale locale) => _cacheLocal.save(localeKey, locale.languageCode);

  @override
  bool? findHideAmounts() => _cacheLocal.get<bool>(hideAmountsKey);

  @override
  Future<void> saveHideAmounts(bool hideAmounts) => _cacheLocal.save(hideAmountsKey, hideAmounts);
}
