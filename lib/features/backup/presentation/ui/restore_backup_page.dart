import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/backup/presentation/view_models/restore_backup_view_model.dart';
import 'package:finan_master_app/main.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/confim_dialog.dart';
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
  final RestoreBackupViewModel viewModel = DI.get<RestoreBackupViewModel>();

  AppBar get appBar => AppBar(
        title: Text(strings.reset),
        bottom: LinearProgressIndicatorAppBar(show: viewModel.isLoading),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: appBar.preferredSize,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return AppBar(
              title: Text(strings.reset),
              bottom: LinearProgressIndicatorAppBar(show: viewModel.isLoading),
            );
          },
        ),
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
              ListenableBuilder(
                listenable: viewModel,
                builder: (_, __) {
                  return FilledButton.icon(
                    onPressed: viewModel.isLoading ? null : restoreBackup,
                    icon: const Icon(Icons.settings_backup_restore_outlined),
                    label: Text(strings.restoreBackup),
                  );
                },
              ),
              const Spacing.y(2),
              Text(strings.or, style: textTheme.titleMedium, textAlign: TextAlign.center),
              const Spacing.y(2),
              Text(strings.deleteDataExplication, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
              const Spacing.y(),
              ListenableBuilder(
                listenable: viewModel,
                builder: (_, __) {
                  return OutlinedButton.icon(
                    onPressed: viewModel.isLoading ? null : deleteAppData,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(strings.deleteData),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> restoreBackup() async {
    try {
      await viewModel.restoreBackup.execute();
      viewModel.restoreBackup.throwIfError();

      if (!mounted) return;

      reset();
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> deleteAppData() async {
    try {
      final bool confirm = await ConfirmDialog.show(context: context, title: strings.deleteData, message: strings.deleteDataConfirmation);
      if (!confirm) return;

      await viewModel.deleteAppData.execute();
      viewModel.deleteAppData.throwIfError();

      if (!mounted) return;

      reset();
    } catch (e) {
      if (!mounted) return;
      await ErrorDialog.show(context, e.toString());
    }
  }
}
