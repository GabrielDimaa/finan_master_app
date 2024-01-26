import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_destination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBarRail extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const NavBarRail({super.key, required this.navigationShell});

  @override
  State<NavBarRail> createState() => _NavBarRailState();
}

class _NavBarRailState extends State<NavBarRail> with ThemeContext {
  ///[initialLocation: index == navigationShell.currentIndex]
  ///Ao tocar no item que já está ativo, deverá navegar para o local inicial.
  void goBranch(int index) => widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);

  List<NavBarRailDestination> get destinations => [
        NavBarRailDestination(description: strings.home, icon: Icons.home_outlined, iconSelected: Icons.home),
        NavBarRailDestination(description: strings.transactions, icon: Icons.sync_alt_outlined, iconSelected: Icons.sync_alt),
        NavBarRailDestination(description: strings.reports, icon: Icons.bar_chart_outlined, iconSelected: Icons.bar_chart),
        NavBarRailDestination(description: strings.settings, icon: Icons.settings_outlined, iconSelected: Icons.settings),
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth < 800) {
          return Scaffold(
            body: widget.navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: goBranch,
              destinations: destinations.map((e) => NavigationDestination(icon: Icon(e.icon), label: e.description, selectedIcon: Icon(e.iconSelected))).toList(),
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: widget.navigationShell.currentIndex,
                  onDestinationSelected: goBranch,
                  groupAlignment: 0,
                  destinations: destinations.map((e) => NavigationRailDestination(icon: Icon(e.icon), label: Text(e.description), selectedIcon: Icon(e.iconSelected))).toList(),
                ),
                Expanded(child: widget.navigationShell),
              ],
            ),
          );
        }
      },
    );
  }
}
