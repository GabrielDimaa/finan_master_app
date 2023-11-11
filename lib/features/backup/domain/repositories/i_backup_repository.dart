import 'dart:io';

abstract interface class IBackupRepository {
  Future<File> backup();

  Future<void> restoreBackup(File file);

  Future<void> saveLastBackupDate(DateTime dateTime);

  DateTime? findLastBackupDate();

  Future<bool> shareBackup(File backupFile);

  Future<File?> pickBackup();
}
