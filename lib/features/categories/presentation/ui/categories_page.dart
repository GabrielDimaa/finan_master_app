import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  static const String route = 'categories';
  static const int indexDrawer = 0;

  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with ThemeContext {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Tab> get tabs => [Tab(text: strings.expenses), Tab(text: strings.incomes)];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text(strings.categories),
          centerTitle: true,
          bottom: TabBar(tabs: tabs),
        ),
        drawer: const NavDrawer(selectedIndex: CategoriesPage.indexDrawer),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.local_gas_station_outlined)),
                    title: Text("Combustível"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  );
                },
              ),
              Column(
                children: [
                  FilledButton(onPressed: () {}, child: Text("Filled button")),
                  Spacing.y(),
                  FilledButton.icon(onPressed: () {}, icon: Icon(Icons.add), label: Text("Filled button")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
