import 'dart:io';
import 'dart:ui';

import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class LocaleNotifier extends ValueNotifier<Locale> {
  final IConfigFind _configFind;
  final IConfigSave _configSave;

  LocaleNotifier({
    required IConfigFind configFind,
    required IConfigSave configSave,
  })  : _configFind = configFind,
        _configSave = configSave,
        super(Locale(Platform.localeName.split('_').first)) {
    find();
  }

  void find() {
    final result = _configFind.findLocale();

    if (result.isSuccess()) {
      value = result.successOrNull()!;

      if (AppLocale().locale.languageCode != value.languageCode) {
        AppLocale().changeLocale(value);
      }
    }
  }

  void changeAndSave(Locale locale) {
    value = locale;
    save(locale);
  }

  Future<void> save(Locale locale) => _configSave.saveLocale(locale);
}
