import 'package:finan_master_app/features/reports/presentation/ui/report_categories_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsPage extends StatefulWidget {
  static const String route = 'reports';

  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with ThemeContext {
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
        title: Text(strings.reports),
        centerTitle: true,
      ),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(strings.categories),
                trailing: const Icon(Icons.chevron_right),
                onTap: categories,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> categories() => context.pushNamed(ReportCategoriesPage.route);
}
