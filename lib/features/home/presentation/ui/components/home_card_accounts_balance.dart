import 'package:finan_master_app/features/account/presentation/ui/accounts_list_page.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/hide_amounts_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_accounts_balance_notifier.dart';
import 'package:finan_master_app/features/home/presentation/states/home_accounts_balance_state.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeCardAccountsBalance extends StatefulWidget {
  final HomeAccountsBalanceNotifier notifier;
  final HideAmountsNotifier hideAmountsNotifier;

  const HomeCardAccountsBalance({super.key, required this.notifier, required this.hideAmountsNotifier});

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
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: textTheme.headlineSmall?.fontSize ?? 20),
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
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              ),
                            );
                          }

                          return ValueListenableBuilder(
                            valueListenable: widget.hideAmountsNotifier,
                            builder: (_, state, __) {
                              if (state) return Text('●●●●', style: textTheme.headlineSmall);

                              return Text(widget.notifier.balance.money, style: textTheme.headlineSmall);
                            },
                          );
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
