import 'dart:io';

import 'package:finan_master_app/features/backup/domain/use_cases/i_backup.dart';
import 'package:finan_master_app/features/backup/presentation/states/backup_state.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class BackupNotifier extends ValueNotifier<BackupState> {
  final IBackup _backup;

  BackupNotifier({required IBackup backup})
      : _backup = backup,
        super(BackupState.start()) {
    loadLastBackupDate();
  }

  File? backupFile;
  DateTime? lastBackupDate;

  bool get isLoading => value is LoadingBackupState;

  bool get isFinalized => value is FinalizedBackupState;

  void loadLastBackupDate() => lastBackupDate = _backup.findLastBackupDate();

  Future<void> backup() async {
    try {
      value = value.setLoading();

      backupFile ??= await _backup.backup();
      final bool success = await _backup.shareBackup(backupFile!);

      if (!success) {
        value = value.setError(R.strings.unsharedBackup);
        return;
      }

      final DateTime dateTime = DateTime.now();
      await _backup.saveLastBackupDate(dateTime);
      lastBackupDate = dateTime;

      value = value.setFinalized();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
