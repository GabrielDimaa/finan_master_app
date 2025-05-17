import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountsListBottomSheet extends StatefulWidget {
  final AccountEntity? accountSelected;
  final List<AccountEntity> accounts;
  final void Function(AccountEntity)? onAccountCreated;

  const AccountsListBottomSheet({
    Key? key,
    required this.accountSelected,
    required this.accounts,
    this.onAccountCreated,
  }) : super(key: key);

  static Future<AccountEntity?> show({
    required BuildContext context,
    required AccountEntity? accountSelected,
    required List<AccountEntity> accounts,
    void Function(AccountEntity)? onAccountCreated,
  }) async {
    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => AccountsListBottomSheet(accountSelected: accountSelected, accounts: accounts, onAccountCreated: onAccountCreated),
    );
  }

  @override
  State<AccountsListBottomSheet> createState() => _AccountsListBottomSheetState();
}

class _AccountsListBottomSheetState extends State<AccountsListBottomSheet> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      builder: (scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(strings.accounts, style: textTheme.titleMedium),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Visibility(
                  visible: widget.accounts.isNotEmpty,
                  replacement: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.manage_search_outlined, size: 36),
                      const Spacing.y(),
                      Text(strings.noAccountsRegistered),
                    ],
                  ),
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: widget.accounts.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final AccountEntity account = widget.accounts[index];
                      return RadioListTile<AccountEntity>(
                        title: Row(
                          children: [
                            account.financialInstitution!.icon(),
                            const Spacing.x(),
                            Expanded(child: Text(account.description)),
                          ],
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        toggleable: true,
                        value: account,
                        groupValue: account.id == widget.accountSelected?.id ? account : null,
                        onChanged: (_) => context.pop(account),
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.add_outlined),
                  label: Text(strings.newAccount),
                  onPressed: goAccount,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> goAccount() async {
    final FormResultNavigation<AccountEntity>? result = await context.pushNamedWithAd(AccountFormPage.route);

    if (result?.isSave == true && result?.value != null) {
      widget.accounts.add(result!.value!);
      widget.onAccountCreated?.call(result.value!);
    }
  }
}
