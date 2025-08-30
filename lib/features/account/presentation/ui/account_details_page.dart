import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/readjust_balance_dialog.dart';
import 'package:finan_master_app/features/account/presentation/view_models/account_details_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
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
  final AccountDetailsViewModel viewModel = DI.get<AccountDetailsViewModel>();

  bool accountChanged = false;

  @override
  void initState() {
    super.initState();

    viewModel.setAccount(widget.account);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, __) {
        return WillPopScope(
          // canPop: !accountChanged,
          // onPopInvoked: (_) => context.pop(FormResultNavigation.save(notifier.account)),
          onWillPop: () async {
            if (accountChanged) {
              context.pop(FormResultNavigation.save(viewModel.account));
            }
            return true;
          },
          child: SliverScaffold(
            appBar: SliverAppBarMedium(
              title: Text(strings.accountDetails),
              loading: viewModel.delete.running,
              actions: [
                PopupMenuButton(
                  tooltip: strings.moreOptions,
                  enabled: !viewModel.delete.running,
                  icon: const Icon(Icons.more_vert_outlined),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      enabled: !viewModel.delete.running,
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
                      enabled: !viewModel.delete.running,
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
                      Text(viewModel.account.description, style: textTheme.titleLarge),
                      const Spacing.y(1.5),
                      Text(strings.accountBalance),
                      const Spacing.y(0.5),
                      Text(viewModel.account.balance.money, style: textTheme.headlineLarge),
                      const Spacing.y(0.5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          viewModel.account.financialInstitution!.icon(24),
                          const Spacing.x(),
                          Text(viewModel.account.financialInstitution!.description, style: textTheme.titleMedium),
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
              ],
            ),
          ),
        );
      }
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
    if (viewModel.delete.running) return;

    final FormResultNavigation? result = await context.pushNamedWithAd(AccountFormPage.route, extra: viewModel.account);

    if (result?.isSave ?? false) {
      viewModel.setAccount(result!.value);
      accountChanged = true;
    }

    if (result?.isDelete ?? false) {
      if (!mounted) return;
      context.pop(FormResultNavigation<AccountEntity>.delete());
    }
  }

  Future<void> readjustBalance() async {
    if (viewModel.delete.running) return;

    final AccountEntity? account = await ReadjustBalance.show(context: context, account: viewModel.account);
    if (account == null) return;

    viewModel.setAccount(account);
    accountChanged = true;
  }

  Future<void> delete() async {
    try {
      if (viewModel.delete.running) return;

      final bool confirm = await ConfirmDialog.show(context: context, title: strings.deleteAccount, message: strings.deleteAccountConfirmation);
      if (!confirm) return;

      await viewModel.delete.execute(viewModel.account);

      viewModel.delete.throwIfError();

      if (!mounted) return;
      context.pop(FormResultNavigation<AccountEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }
}
