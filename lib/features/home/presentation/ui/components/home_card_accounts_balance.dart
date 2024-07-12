import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/ui/accounts_list_page.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_accounts_balance_notifier.dart';
import 'package:finan_master_app/features/home/presentation/states/home_accounts_balance_state.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeCardAccountsBalance extends StatefulWidget {
  final HomeAccountsBalanceNotifier notifier;

  const HomeCardAccountsBalance({super.key, required this.notifier});

  @override
  State<HomeCardAccountsBalance> createState() => _HomeCardAccountsBalanceState();
}

class _HomeCardAccountsBalanceState extends State<HomeCardAccountsBalance> with ThemeContext {
  late HomeAccountsBalanceState state;

  @override
  void initState() {
    super.initState();
    state = widget.notifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 90),
      child: Card(
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
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
                    SizedBox(
                      height: textTheme.headlineSmall!.fontSize,
                      child: ValueListenableBuilder(
                        valueListenable: widget.notifier,
                        builder: (_, state, __) {
                          final lastState = this.state;
                          this.state = state;

                          if (state is ErrorHomeAccountsBalanceState) {
                            return Text(
                              state.message.replaceAll('Exception: ', ''),
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            );
                          }

                          if (state is StartHomeAccountsBalanceState || (state is LoadingHomeAccountsBalanceState && lastState is! LoadedHomeAccountsBalanceState)) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 3),
                              ),
                            );
                          }

                          return Text(widget.notifier.balance.money, style: textTheme.headlineSmall);
                        },
                      ),
                    ),
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
      ),
    );
  }

  void seeAllAccounts() => context.goNamed(AccountsListPage.route);
}
