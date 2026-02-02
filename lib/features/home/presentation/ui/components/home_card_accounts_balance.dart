import 'package:finan_master_app/features/account/presentation/ui/accounts_list_page.dart';
import 'package:finan_master_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeCardAccountsBalance extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeCardAccountsBalance({super.key, required this.viewModel});

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
                      child: ListenableBuilder(
                        listenable: widget.viewModel.loadAccountsBalance,
                        builder: (_, __) {
                          final prev = widget.viewModel.loadAccountsBalance.previous;

                          if (widget.viewModel.loadAccountsBalance.hasError) {
                            return Text(
                              widget.viewModel.loadAccountsBalance.error.toString().replaceAll('Exception: ', ''),
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            );
                          }

                          if (widget.viewModel.loadAccountsBalance.running && prev?.completed != true) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              ),
                            );
                          }

                          return ListenableBuilder(
                            listenable: widget.viewModel,
                            builder: (_, __) {
                              if (widget.viewModel.hideAmounts) return Text('●●●●', style: textTheme.headlineSmall);

                              return Text((widget.viewModel.loadAccountsBalance.result ?? prev?.result)!.money, style: textTheme.headlineSmall);
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
