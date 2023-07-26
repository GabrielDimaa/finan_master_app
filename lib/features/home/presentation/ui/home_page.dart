import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String route = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ThemeContext {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      scaffoldKey: scaffoldKey,
      appBar: SliverAppBarSmall(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(strings.home),
        centerTitle: true,
      ),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(strings.home),
            ),
          ],
        ),
      ),
    );
  }
}
