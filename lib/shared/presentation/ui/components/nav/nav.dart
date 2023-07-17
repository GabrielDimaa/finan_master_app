import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum NavDestination {
  home('Início', Icons.home_outlined, Icons.home),
  // transactions('Transações', Icons.sync_alt_outlined, Icons.sync_alt),
  config('Configurações', Icons.settings_outlined, Icons.settings);

  final String description;
  final IconData icon;
  final IconData iconSelected;

  const NavDestination(this.description, this.icon, this.iconSelected);
}

class Nav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const Nav({super.key, required this.navigationShell});

  ///[initialLocation: index == navigationShell.currentIndex]
  ///Ao tocar no item que já está ativo, deverá navegar para o local inicial.
  void _goBranch(int index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth < 450) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              destinations: NavDestination.values.map((e) => NavigationDestination(icon: Icon(e.icon), label: e.description, selectedIcon: Icon(e.iconSelected),)).toList(),
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _goBranch,
                  groupAlignment: 0,
                  leading: const Icon(Icons.menu),
                  destinations: NavDestination.values.map((e) => NavigationRailDestination(icon: Icon(e.icon), label: Text(e.description), selectedIcon: Icon(e.iconSelected))).toList(),
                ),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }
      },
    );
  }
}
