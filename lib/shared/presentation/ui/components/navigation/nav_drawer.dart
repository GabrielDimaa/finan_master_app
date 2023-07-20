import 'package:finan_master_app/features/categories/presentation/ui/categories_page.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavDrawer extends StatefulWidget {
  final int? selectedIndex;

  const NavDrawer({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> with ThemeContext {
  Map<int, NavigationDrawerDestination> get destinations => {
    CategoriesPage.indexDrawer: NavigationDrawerDestination(label: Text(strings.categories), icon: const Icon(Icons.category_outlined), selectedIcon: const Icon(Icons.category)),
    1: NavigationDrawerDestination(label: Text(strings.cards), icon: const Icon(Icons.credit_card_outlined), selectedIcon: const Icon(Icons.credit_card)),
    2: NavigationDrawerDestination(label: Text(strings.accounts), icon: const Icon(Icons.account_balance_outlined), selectedIcon: const Icon(Icons.account_balance)),
    3: NavigationDrawerDestination(label: Text(strings.backup), icon: const Icon(Icons.backup_outlined), selectedIcon: const Icon(Icons.backup))
  };

  void onDestinationSelected(int? index) {
    switch (index) {
      case CategoriesPage.indexDrawer:
        context.goNamed(CategoriesPage.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: onDestinationSelected,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            strings.menu,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        destinations[CategoriesPage.indexDrawer]!,
        destinations[1]!,
        destinations[2]!,
        const Divider(),
        destinations[3]!,
      ],
    );
  }
}
