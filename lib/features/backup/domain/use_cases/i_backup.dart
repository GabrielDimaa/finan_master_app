import 'dart:io';

abstract interface class IBackup {
  Future<File> backup();

  Future<void> saveLastBackupDate(DateTime dateTime);

  DateTime? findLastBackupDate();

  Future<bool> shareBackup(File backupFile);
}
