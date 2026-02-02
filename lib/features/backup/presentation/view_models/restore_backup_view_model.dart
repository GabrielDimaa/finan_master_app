import 'package:finan_master_app/features/backup/domain/use_cases/i_restore_backup.dart';
import 'package:finan_master_app/shared/domain/domain/i_delete_app_data.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/cupertino.dart';

class RestoreBackupViewModel extends ChangeNotifier {
  late final Command0 restoreBackup;
  late final Command0 deleteAppData;

  RestoreBackupViewModel({required IRestoreBackup restoreBackup, required IDeleteAppData deleteAppData}) {
    this.restoreBackup = Command0(restoreBackup.restore);
    this.deleteAppData = Command0(deleteAppData.delete);
  }

  bool get isLoading => restoreBackup.running || deleteAppData.running;
}
