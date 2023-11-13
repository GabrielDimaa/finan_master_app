import 'package:finan_master_app/features/backup/presentation/notifiers/backup_notifier.dart';
import 'package:finan_master_app/features/backup/presentation/states/backup_state.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/linear_progress_indicator_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BackupPage extends StatefulWidget {
  static const String route = 'backup';
  static const int indexDrawer = 3;

  const BackupPage({Key? key}) : super(key: key);

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> with ThemeContext {
  final BackupNotifier notifier = GetIt.I.get<BackupNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, state, __) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(strings.backup),
            bottom: state is LoadingBackupState ? const LinearProgressIndicatorAppBar() : null,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacing.y(5),
                  const Icon(Icons.backup_outlined, size: 90),
                  const Spacing.y(2),
                  Text(strings.backupTitleExplication, style: textTheme.titleMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(strings.backupSubtitleExplication, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
                  const Spacing.y(4),
                  FilledButton.icon(
                    onPressed: notifier.isLoading || notifier.isFinalized ? null : backup,
                    icon: notifier.isFinalized ? const Icon(Icons.check) : const Icon(Icons.file_download_outlined),
                    label: notifier.isFinalized ? Text(strings.backupButtonFinalized) : Text(strings.backupButton),
                  ),
                  const Spacing.y(2),
                  Text(
                    '${strings.lastBackupDate}: ${notifier.lastBackupDate?.format() ?? strings.unrealized}',
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> backup() async {
    if (notifier.isLoading) return;

    try {
      await notifier.backup();
      if (notifier.value is ErrorBackupState) throw Exception((notifier.value as ErrorBackupState).message);
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }
}
