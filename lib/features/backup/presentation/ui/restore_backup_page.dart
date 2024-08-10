import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/backup/presentation/notifiers/backup_notifier.dart';
import 'package:finan_master_app/features/backup/presentation/states/backup_state.dart';
import 'package:finan_master_app/features/splash/presentation/ui/splash_page.dart';
import 'package:finan_master_app/main.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/linear_progress_indicator_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class RestoreBackupPage extends StatefulWidget {
  static const String route = 'restore-backup';

  const RestoreBackupPage({Key? key}) : super(key: key);

  @override
  State<RestoreBackupPage> createState() => _RestoreBackupPageState();
}

class _RestoreBackupPageState extends State<RestoreBackupPage> with ThemeContext {
  final BackupNotifier notifier = DI.get<BackupNotifier>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, state, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(strings.reset),
            bottom: state is LoadingBackupState ? const LinearProgressIndicatorAppBar() : null,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacing.y(5),
                  const Icon(Icons.delete_forever_outlined, size: 90),
                  const Spacing.y(2),
                  Text(strings.resetDataTitle, style: textTheme.titleMedium, textAlign: TextAlign.center),
                  const Spacing.y(4),
                  Text(strings.restoreBackupExplication, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
                  const Spacing.y(),
                  FilledButton.icon(
                    onPressed: notifier.isLoading ? null : restoreBackup,
                    icon: const Icon(Icons.settings_backup_restore_outlined),
                    label: Text(strings.restoreBackup),
                  ),
                  const Spacing.y(2),
                  Text(strings.or, style: textTheme.titleMedium, textAlign: TextAlign.center),
                  const Spacing.y(2),
                  Text(strings.deleteDataExplication, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
                  const Spacing.y(),
                  OutlinedButton.icon(
                    onPressed: notifier.isLoading ? null : deleteAppData,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(strings.deleteData),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> restoreBackup() async {
    try {
      await notifier.restoreBackup();
      if (notifier.value is ErrorBackupState) throw Exception((notifier.value as ErrorBackupState).message);

      if (!mounted) return;

      reset();
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> deleteAppData() async {
    try {
      await notifier.deleteAppData();
      if (notifier.value is ErrorBackupState) throw Exception((notifier.value as ErrorBackupState).message);

      if (!mounted) return;

      reset();
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }
}
