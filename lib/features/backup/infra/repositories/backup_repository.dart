import 'dart:io';

import 'package:finan_master_app/features/backup/domain/repositories/i_backup_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/drivers/file_picker/i_file_picker_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/share/i_share_driver.dart';
import 'package:path_provider/path_provider.dart';

class BackupRepository implements IBackupRepository {
  final IDatabaseLocal _databaseLocal;
  final ICacheLocal _cacheLocal;
  final IShareDriver _shareDriver;
  final IFilePickerDriver _filePickerDriver;

  BackupRepository({
    required IDatabaseLocal databaseLocal,
    required ICacheLocal cacheLocal,
    required IShareDriver shareDriver,
    required IFilePickerDriver filePickerDriver,
  })  : _databaseLocal = databaseLocal,
        _cacheLocal = cacheLocal,
        _shareDriver = shareDriver,
        _filePickerDriver = filePickerDriver;

  static const String lastBackupDateKey = 'last_backup_date';

  @override
  Future<File> backup() async {
    final File fileDatabase = await _databaseLocal.getFileDatabase();

    final Directory tempDirectory = await getTemporaryDirectory();
    final File backupFile = File('${tempDirectory.path}/finan_master_backup.db');

    await backupFile.writeAsBytes(fileDatabase.readAsBytesSync());

    return backupFile;
  }

  @override
  Future<void> restoreBackup(File file) async {
    final File fileDatabaseLocal = await _databaseLocal.getFileDatabase();
    fileDatabaseLocal.writeAsBytesSync(file.readAsBytesSync());
  }

  @override
  Future<void> saveLastBackupDate(DateTime dateTime) => _cacheLocal.save(lastBackupDateKey, dateTime.toIso8601String());

  @override
  DateTime? findLastBackupDate() => DateTime.tryParse(_cacheLocal.get(lastBackupDateKey) ?? '')?.toLocal();

  @override
  Future<bool> shareBackup(File backupFile) => _shareDriver.shareFiles([backupFile]);

  @override
  Future<File?> pickBackup() => _filePickerDriver.pickFile(allowedExtensions: Platform.isWindows ? ['db'] : null);
}
