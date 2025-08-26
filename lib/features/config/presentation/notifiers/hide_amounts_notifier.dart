import 'dart:io';
import 'dart:ui';

import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class HideAmountsNotifier extends ValueNotifier<bool> {
  final IConfigFind _configFind;
  final IConfigSave _configSave;

  HideAmountsNotifier({
    required IConfigFind configFind,
    required IConfigSave configSave,
  })  : _configFind = configFind,
        _configSave = configSave,
        super(false) {
    find();
  }

  void find() {
    value = _configFind.findHideAmounts();
  }

  void changeAndSave(bool value) {
    this.value = value;
    save(value);
  }

  Future<void> save(bool value) => _configSave.saveHideAmounts(value);
}
