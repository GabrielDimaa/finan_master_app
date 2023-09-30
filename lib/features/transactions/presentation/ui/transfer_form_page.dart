import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/accounts_list_bottom_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transfer_notifier.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/date_picker.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/mask/mask_input_formatter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_greater_than_value.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/group_tile.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransferFormPage extends StatefulWidget {
  static const route = 'transfer-form';

  const TransferFormPage({Key? key}) : super(key: key);

  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> with ThemeContext {
  final TransferNotifier notifier = GetIt.I.get<TransferNotifier>();
  final AccountsNotifier accountsNotifier = GetIt.I.get<AccountsNotifier>();

  final ValueNotifier<bool> initialLoadingNotifier = ValueNotifier(false);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    dateController.text = notifier.transfer.date.format();

    Future(() async {
      try {
        initialLoadingNotifier.value = true;
        accountsNotifier.findAll();
      } finally {
        initialLoadingNotifier.value = false;
      }

      if (!mounted) return;

      if (accountsNotifier.value is ErrorAccountsState) {
        ErrorDialog.show(context, (accountsNotifier.value as ErrorAccountsState).message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: initialLoadingNotifier,
      builder: (_, initialLoading, __) {
        return ValueListenableBuilder(
          valueListenable: notifier,
          builder: (_, state, __) {
            return SliverScaffold(
              appBar: SliverAppBarMedium(
                title: Text(strings.transfer),
                loading: notifier.isLoading,
                actions: [
                  FilledButton(
                    onPressed: save,
                    child: Text(strings.save),
                  ),
                ],
              ),
              body: Builder(
                builder: (_) {
                  if (initialLoading) return const SizedBox.shrink();

                  return ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (_, state, __) {
                      return Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const Spacing.y(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      label: Text(strings.amount),
                                      prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                                    ),
                                    validator: InputGreaterThanValueValidator().validate,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    enabled: !notifier.isLoading,
                                    onSaved: (String? value) => state.transfer.amount = (value ?? '').moneyToDouble(),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                                  ),
                                  const Spacing.y(),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                                      label: Text(strings.date),
                                    ),
                                    readOnly: true,
                                    controller: dateController,
                                    validator: InputRequiredValidator().validate,
                                    enabled: !notifier.isLoading,
                                    onTap: selectDate,
                                  ),
                                ],
                              ),
                            ),
                            const Spacing.y(),
                            const Divider(),
                            GroupTile(
                              onTap: selectAccountFrom,
                              title: strings.from,
                              enabled: !notifier.isLoading,
                              tile: state.transfer.transactionFrom.idAccount != null
                                  ? Builder(
                                      builder: (_) {
                                        final AccountEntity account = accountsNotifier.value.accounts.firstWhere((account) => account.id == state.transfer.transactionFrom.idAccount);
                                        return ListTile(
                                          leading: account.financialInstitution!.icon(),
                                          title: Text(account.description),
                                          trailing: const Icon(Icons.chevron_right),
                                          enabled: !notifier.isLoading,
                                        );
                                      },
                                    )
                                  : ListTile(
                                      leading: const Icon(Icons.account_balance_outlined),
                                      title: Text(strings.selectAccount),
                                      trailing: const Icon(Icons.chevron_right),
                                      enabled: !notifier.isLoading,
                                    ),
                            ),
                            const Divider(),
                            GroupTile(
                              onTap: selectAccountTo,
                              title: strings.to,
                              enabled: !notifier.isLoading,
                              tile: state.transfer.transactionTo.idAccount != null
                                  ? Builder(
                                      builder: (_) {
                                        final AccountEntity account = accountsNotifier.value.accounts.firstWhere((account) => account.id == state.transfer.transactionTo.idAccount);
                                        return ListTile(
                                          leading: account.financialInstitution!.icon(),
                                          title: Text(account.description),
                                          trailing: const Icon(Icons.chevron_right),
                                          enabled: !notifier.isLoading,
                                        );
                                      },
                                    )
                                  : ListTile(
                                      leading: const Icon(Icons.account_balance_outlined),
                                      title: Text(strings.selectAccount),
                                      trailing: const Icon(Icons.chevron_right),
                                      enabled: !notifier.isLoading,
                                    ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> save() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await notifier.save();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(notifier.transfer));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectAccountFrom() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    final AccountEntity? result = await showAccountListBottomSheet(notifier.transfer.transactionFrom.idAccount);
    if (result == null) return;

    notifier.setAccountFrom(result.id);
  }

  Future<void> selectAccountTo() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    final AccountEntity? result = await showAccountListBottomSheet(notifier.transfer.transactionTo.idAccount);
    if (result == null) return;

    notifier.setAccountTo(result.id);
  }

  Future<AccountEntity?> showAccountListBottomSheet(String? idAccount) async {
    return await AccountsListBottomSheet.show(
      context: context,
      accountSelected: accountsNotifier.value.accounts.firstWhereOrNull((account) => account.id == idAccount),
      accounts: accountsNotifier.value.accounts,
    );
  }

  Future<void> selectDate() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    final DateTime? result = await showDatePickerDefault(context: context, initialDate: notifier.transfer.date);

    if (result == null || result == notifier.transfer.date) return;

    dateController.text = result.format();
    notifier.setDate(result);
  }
}
