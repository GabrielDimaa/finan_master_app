import 'dart:io';

import 'package:finan_master_app/features/backup/domain/repositories/i_backup_repository.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/i_backup.dart';

class Backup implements IBackup {
  final IBackupRepository _repository;

  Backup({required IBackupRepository repository}) : _repository = repository;

  @override
  Future<File> backup() => _repository.backup();

  @override
  Future<void> saveLastBackupDate(DateTime dateTime) => _repository.saveLastBackupDate(dateTime);

  @override
  DateTime? findLastBackupDate() => _repository.findLastBackupDate();

  @override
  Future<bool> shareBackup(File backupFile) => _repository.shareBackup(backupFile);
}
