import 'package:finan_master_app/features/backup/presentation/notifiers/backup_notifier.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RestoreBackupPage extends StatefulWidget {
  static const String route = 'restore-backup';

  const RestoreBackupPage({Key? key}) : super(key: key);

  @override
  State<RestoreBackupPage> createState() => _RestoreBackupPageState();
}

class _RestoreBackupPageState extends State<RestoreBackupPage> with ThemeContext {
  final BackupNotifier notifier = GetIt.I.get<BackupNotifier>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(strings.reset)),
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
                onPressed: () {},
                icon: const Icon(Icons.settings_backup_restore_outlined),
                label: Text(strings.restoreBackup),
              ),
              const Spacing.y(2),
              Text(strings.or, style: textTheme.titleMedium, textAlign: TextAlign.center),
              const Spacing.y(2),
              Text(strings.deleteDataExplication, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
              const Spacing.y(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline),
                label: Text(strings.deleteData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
