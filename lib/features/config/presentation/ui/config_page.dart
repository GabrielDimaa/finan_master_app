import 'package:finan_master_app/features/backup/domain/use_cases/i_restore_backup.dart';
import 'package:finan_master_app/features/backup/presentation/ui/restore_backup_page.dart';
import 'package:finan_master_app/features/config/presentation/ui/components/languages.dart';
import 'package:finan_master_app/features/config/presentation/ui/components/switch_theme_mode.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ConfigPage extends StatefulWidget {
  static const String route = 'config';

  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> with ThemeContext {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.menu,
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(strings.settings),
        centerTitle: true,
      ),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(strings.language),
                trailing: const Icon(Icons.chevron_right),
                onTap: language,
              ),
              const Divider(),
              const SwitchThemeMode(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined),
                title: Text(strings.reset),
                trailing: const Icon(Icons.chevron_right),
                onTap: goRestoreBackup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> language() => Languages.show(context);

  void goRestoreBackup() => context.pushNamed(RestoreBackupPage.route);
}
