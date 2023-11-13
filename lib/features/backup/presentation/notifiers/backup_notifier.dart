import 'dart:io';

import 'package:finan_master_app/features/backup/domain/use_cases/i_backup.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/i_restore_backup.dart';
import 'package:finan_master_app/features/backup/presentation/states/backup_state.dart';
import 'package:finan_master_app/shared/domain/domain/i_delete_app_data.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class BackupNotifier extends ValueNotifier<BackupState> {
  final IBackup _backup;
  final IRestoreBackup _restoreBackup;
  final IDeleteAppData _deleteAppData;

  BackupNotifier({required IBackup backup, required IRestoreBackup restoreBackup, required IDeleteAppData deleteAppData})
      : _backup = backup,
        _restoreBackup = restoreBackup,
        _deleteAppData = deleteAppData,
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

  Future<void> restoreBackup() async {
    try {
      value = value.setLoading();
      await _restoreBackup.restore();
      value = value.setFinalized();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> deleteAppData() async {
    try {
      value = value.setLoading();
      await _deleteAppData.delete();
      value = value.setFinalized();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
