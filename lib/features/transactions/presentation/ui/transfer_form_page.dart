import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/accounts_list_bottom_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transfer_notifier.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
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

  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    dateController.text = DateFormat.yMd(AppLocale().locale.languageCode).format(notifier.transfer.date);

    Future(() async {
      try {
        loadingNotifier.value = true;
        accountsNotifier.findAll();
      } finally {
        loadingNotifier.value = false;
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
      valueListenable: loadingNotifier,
      builder: (_, loading, __) {
        return SliverScaffold(
          appBar: SliverAppBarMedium(
            title: Text(strings.transfer),
            loading: loading,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
            ],
          ),
          body: Builder(
            builder: (_) {
              if (loading) return const SizedBox.shrink();

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
                                enabled: !loading,
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
                                enabled: !loading,
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
                          enabled: !loading,
                          tile: state.transfer.transactionFrom.idAccount != null
                              ? Builder(
                                  builder: (_) {
                                    final AccountEntity account = accountsNotifier.value.accounts.firstWhere((account) => account.id == state.transfer.transactionFrom.idAccount);
                                    return ListTile(
                                      leading: account.financialInstitution!.icon(),
                                      title: Text(account.description),
                                      trailing: const Icon(Icons.chevron_right),
                                      enabled: !loading,
                                    );
                                  },
                                )
                              : ListTile(
                                  leading: const Icon(Icons.account_balance_outlined),
                                  title: Text(strings.selectAccount),
                                  trailing: const Icon(Icons.chevron_right),
                                  enabled: !loading,
                                ),
                        ),
                        const Divider(),
                        GroupTile(
                          onTap: selectAccountTo,
                          title: strings.to,
                          enabled: !loading,
                          tile: state.transfer.transactionTo.idAccount != null
                              ? Builder(
                                  builder: (_) {
                                    final AccountEntity account = accountsNotifier.value.accounts.firstWhere((account) => account.id == state.transfer.transactionTo.idAccount);
                                    return ListTile(
                                      leading: account.financialInstitution!.icon(),
                                      title: Text(account.description),
                                      trailing: const Icon(Icons.chevron_right),
                                      enabled: !loading,
                                    );
                                  },
                                )
                              : ListTile(
                                  leading: const Icon(Icons.account_balance_outlined),
                                  title: Text(strings.selectAccount),
                                  trailing: const Icon(Icons.chevron_right),
                                  enabled: !loading,
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
  }

  Future<void> save() async {
    if (loadingNotifier.value) return;

    try {
      loadingNotifier.value = true;

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await notifier.save();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(notifier.transfer));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    } finally {
      loadingNotifier.value = false;
    }
  }

  Future<void> selectAccountFrom() async {
    if (loadingNotifier.value) return;

    final AccountEntity? result = await showAccountListBottomSheet(notifier.transfer.transactionFrom.idAccount);
    if (result == null) return;

    notifier.setAccountFrom(result.id);
  }

  Future<void> selectAccountTo() async {
    if (loadingNotifier.value) return;

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
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: notifier.transfer.date,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );

    if (result == null || result == notifier.transfer.date) return;

    dateController.text = DateFormat.yMd(AppLocale().locale.languageCode).format(result);
    notifier.setDate(result);
  }
}
