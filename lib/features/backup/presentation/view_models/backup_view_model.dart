import 'dart:io';

import 'package:finan_master_app/features/backup/domain/use_cases/i_backup.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class BackupViewModel extends ChangeNotifier {
  final IBackup _backup;

  late final Command0 backupAndShare;

  BackupViewModel({required IBackup backup}) : _backup = backup {
    backupAndShare = Command0(_backupAndShare);
    _lastBackupDate = backup.findLastBackupDate();
  }

  File? _backupFile;
  DateTime? _lastBackupDate;

  DateTime? get lastBackupDate => _lastBackupDate;

  void setLastBackupDate(DateTime value) {
    _lastBackupDate = value;
    notifyListeners();
  }

  Future<void> _backupAndShare() async {
    _backupFile ??= await _backup.backup();

    if (!await _backup.shareBackup(_backupFile!)) throw Exception(R.strings.unsharedBackup);

    final DateTime now = DateTime.now();
    await _backup.saveLastBackupDate(now);
    setLastBackupDate(now);
  }
}
