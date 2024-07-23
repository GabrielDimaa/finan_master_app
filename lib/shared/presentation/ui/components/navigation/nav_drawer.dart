import 'package:finan_master_app/features/account/presentation/ui/accounts_list_page.dart';
import 'package:finan_master_app/features/category/presentation/ui/categories_list_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_cards_details_page.dart';
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
        CategoriesListPage.indexDrawer: NavigationDrawerDestination(label: Text(strings.categories), icon: const Icon(Icons.category_outlined), selectedIcon: const Icon(Icons.category)),
        CreditCardsDetailsPage.indexDrawer: NavigationDrawerDestination(label: Text(strings.creditCards), icon: const Icon(Icons.credit_card_outlined), selectedIcon: const Icon(Icons.credit_card)),
        AccountsListPage.indexDrawer: NavigationDrawerDestination(label: Text(strings.accounts), icon: const Icon(Icons.account_balance_outlined), selectedIcon: const Icon(Icons.account_balance)),
      };

  void onDestinationSelected(int? index) {
    context.pop();
    switch (index) {
      case CategoriesListPage.indexDrawer:
        context.goNamed(CategoriesListPage.route);
        break;
      case CreditCardsDetailsPage.indexDrawer:
        context.goNamed(CreditCardsDetailsPage.route);
        break;
      case AccountsListPage.indexDrawer:
        context.goNamed(AccountsListPage.route);
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
        destinations[CategoriesListPage.indexDrawer]!,
        destinations[CreditCardsDetailsPage.indexDrawer]!,
        destinations[AccountsListPage.indexDrawer]!,
      ],
    );
  }
}
