import 'dart:io';

import 'package:finan_master_app/features/backup/domain/repositories/i_backup_repository.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/i_restore_backup.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:path/path.dart' as path;

class RestoreBackup implements IRestoreBackup {
  final IBackupRepository _repository;

  RestoreBackup({required IBackupRepository repository}) : _repository = repository;

  @override
  Future<void> restore() async {
    final File? file = await _repository.pickBackup();
    if (file == null) return;

    if (path.extension(file.path).compareTo('.db') != 0) throw Exception(R.strings.selectFileInvalid);

    await _repository.restoreBackup(file);
  }
}
