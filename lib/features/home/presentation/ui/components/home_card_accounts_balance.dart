import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/account/presentation/ui/accounts_list_page.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeCardAccountsBalance extends StatefulWidget {
  final AccountsNotifier accountsNotifier;

  const HomeCardAccountsBalance({super.key, required this.accountsNotifier});

  @override
  State<HomeCardAccountsBalance> createState() => _HomeCardAccountsBalanceState();
}

class _HomeCardAccountsBalanceState extends State<HomeCardAccountsBalance> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 90),
      child: Card(
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ValueListenableBuilder(
          valueListenable: widget.accountsNotifier,
          builder: (_, state, __) {
            return switch (state) {
              LoadingAccountsState _ || StartAccountsState _ => const SizedBox.shrink(),
              ErrorAccountsState error => Text(error.message, style: textTheme.bodyLarge?.copyWith(color: colorScheme.error)),
              ListAccountsState _ || EmptyAccountsState _ => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(strings.accountsBalance, style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 4),
                            Text(widget.accountsNotifier.accountsBalance.money, style: textTheme.headlineSmall),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: seeAllAccounts,
                        child: Text(strings.seeAll),
                      ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }

  void seeAllAccounts() => context.goNamed(AccountsListPage.route);
}
