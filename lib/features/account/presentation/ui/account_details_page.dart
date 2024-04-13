import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/account_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/account_state.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/readjust_balance.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/confim_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar_medium.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountDetailsPage extends StatefulWidget {
  static const route = 'account-details';

  final AccountEntity account;

  const AccountDetailsPage({Key? key, required this.account}) : super(key: key);

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> with ThemeContext {
  final AccountNotifier notifier = DI.get<AccountNotifier>();

  bool accountChanged = false;

  bool get isLoading => notifier.value is SavingAccountState || notifier.value is DeletingAccountState;

  @override
  void initState() {
    super.initState();

    notifier.setAccount(widget.account);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !accountChanged,
      onPopInvoked: (_) => context.pop(FormResultNavigation.save(notifier.account)),
      child: ValueListenableBuilder(
        valueListenable: notifier,
        builder: (_, state, __) {
          return SliverScaffold(
            appBar: SliverAppBarMedium(
              title: Text(strings.accountDetails),
              loading: isLoading,
              actions: [
                PopupMenuButton(
                  tooltip: strings.moreOptions,
                  enabled: !isLoading,
                  icon: const Icon(Icons.more_vert_outlined),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      enabled: !isLoading,
                      onTap: goAccountForm,
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 20),
                          const Spacing.x(),
                          Text(strings.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      enabled: !isLoading,
                      onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) => delete()),
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outlined, size: 20),
                          const Spacing.x(),
                          Text(strings.delete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacing.y(),
                      Text(state.account.description, style: textTheme.titleLarge),
                      const Spacing.y(1.5),
                      Text(strings.accountBalance),
                      const Spacing.y(0.5),
                      Text(state.account.balance.money, style: textTheme.headlineLarge),
                      const Spacing.y(0.5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.account.financialInstitution!.icon(24),
                          const Spacing.x(),
                          Text(state.account.financialInstitution!.description, style: textTheme.titleMedium),
                        ],
                      ),
                      const Spacing.y(3),
                      IntrinsicWidth(
                        stepWidth: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: readjustBalance,
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(strings.readjustBalance),
                        ),
                      ),
                      const Spacing.y(2),
                    ],
                  ),
                ),
                const Divider(),
                // Padding(
                //   padding: const EdgeInsets.all(16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: operation(
                //           value: "55",
                //           label: "Receitas",
                //         ),
                //       ),
                //       Expanded(
                //         child: operation(
                //           value: "55",
                //           label: "Despesas",
                //         ),
                //       ),
                //       Expanded(
                //         child: operation(
                //           value: "55",
                //           label: "Transferências",
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const Divider(),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget operation({required String value, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: textTheme.titleLarge),
        Text(label, style: textTheme.labelLarge),
      ],
    );
  }

  Future<void> goAccountForm() async {
    if (isLoading) return;

    final FormResultNavigation? result = await context.pushNamed(AccountFormPage.route, extra: notifier.account);

    if (result?.isSave ?? false) {
      notifier.setAccount(result!.value);
      accountChanged = true;
    }

    if (result?.isDelete ?? false) {
      if (!mounted) return;
      context.pop(FormResultNavigation<AccountEntity>.delete());
    }
  }

  Future<void> readjustBalance() async {
    if (isLoading) return;

    final AccountEntity? account = await ReadjustBalance.show(context: context, account: notifier.account);
    if (account == null) return;

    notifier.setAccount(account);
    accountChanged = true;
  }

  Future<void> delete() async {
    try {
      if (isLoading) return;

      final bool confirm = await ConfirmDialog.show(context: context, title: strings.deleteAccount, message: strings.deleteAccountConfirmation);
      if (!confirm) return;

      await notifier.delete();

      if (!mounted) return;
      context.pop(FormResultNavigation<AccountEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }
}
