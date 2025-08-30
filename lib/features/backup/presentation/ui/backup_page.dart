import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/backup/presentation/view_models/backup_view_model.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/linear_progress_indicator_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class BackupPage extends StatefulWidget {
  static const String route = 'backup';

  const BackupPage({Key? key}) : super(key: key);

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> with ThemeContext {
  final BackupViewModel viewModel = DI.get<BackupViewModel>();

  AppBar get appBar => AppBar(
        title: Text(strings.backup),
        bottom: LinearProgressIndicatorAppBar(show: viewModel.backupAndShare.running),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: appBar.preferredSize,
        child: ListenableBuilder(
          listenable: viewModel.backupAndShare,
          builder: (_, __) => appBar,
        ),
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
              ListenableBuilder(
                listenable: viewModel.backupAndShare,
                builder: (_, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: viewModel.backupAndShare.running || viewModel.backupAndShare.completed ? null : backup,
                        icon: viewModel.backupAndShare.completed ? const Icon(Icons.check) : const Icon(Icons.file_download_outlined),
                        label: viewModel.backupAndShare.completed ? Text(strings.backupButtonFinalized) : Text(strings.backupButton),
                      ),
                      const Spacing.y(2),
                      Text(
                        '${strings.lastBackupDate}: ${viewModel.lastBackupDate?.format() ?? strings.unrealized}',
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> backup() async {
    if (viewModel.backupAndShare.running) return;

    try {
      await viewModel.backupAndShare.execute();
      viewModel.backupAndShare.throwIfError();
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }
}
