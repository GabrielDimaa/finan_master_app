import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/accounts_list_bottom_sheet.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/card_brand_list_bottom_sheet.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/mask/mask_input_formatter.dart';
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

class CreditCardFormPage extends StatefulWidget {
  static const route = 'credit_card-form';

  final CreditCardEntity? creditCard;

  const CreditCardFormPage({Key? key, this.creditCard}) : super(key: key);

  @override
  State<CreditCardFormPage> createState() => _CreditCardFormPageState();
}

class _CreditCardFormPageState extends State<CreditCardFormPage> with ThemeContext {
  final CreditCardNotifier notifier = GetIt.I.get<CreditCardNotifier>();
  final AccountsNotifier accountsNotifier = GetIt.I.get<AccountsNotifier>();
  final ValueNotifier<bool> initialLoadingNotifier = ValueNotifier(false);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        initialLoadingNotifier.value = true;

        if (widget.creditCard != null) notifier.setCreditCard(widget.creditCard!);

        await accountsNotifier.findAll();
      } catch (e) {
        if (!mounted) return;
        ErrorDialog.show(context, e.toString());
      } finally {
        initialLoadingNotifier.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: initialLoadingNotifier,
        builder: (_, loading, __) {
          if (loading) return const Center(child: CircularProgressIndicator());

          return ValueListenableBuilder(
            valueListenable: notifier,
            builder: (_, state, __) {
              return SliverScaffold(
                appBar: SliverAppBarMedium(
                  title: Text(strings.creditCard),
                  loading: notifier.isLoading,
                  actions: [
                    FilledButton(
                      onPressed: save,
                      child: Text(strings.save),
                    ),
                    if (!state.creditCard.isNew)
                      IconButton(
                        tooltip: strings.delete,
                        onPressed: delete,
                        icon: const Icon(Icons.delete_outline),
                      ),
                  ],
                ),
                body: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Spacing.y(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: state.creditCard.description,
                              decoration: InputDecoration(label: Text(strings.description)),
                              validator: InputRequiredValidator().validate,
                              textInputAction: TextInputAction.next,
                              enabled: !notifier.isLoading,
                              onSaved: (String? value) => state.creditCard.description = value ?? '',
                            ),
                            const Spacing.y(),
                            TextFormField(
                              initialValue: state.creditCard.amountLimit.moneyWithoutSymbol,
                              decoration: InputDecoration(
                                label: Text(strings.limit),
                                prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                              ),
                              validator: InputRequiredValidator().validate,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              enabled: !notifier.isLoading,
                              onSaved: (String? value) => state.creditCard.amountLimit = (value ?? '').moneyToDouble(),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                            ),
                            const Spacing.y(),
                            Row(
                              children: [
                                DropdownMenu<int>(
                                  initialSelection: state.creditCard.invoiceClosingDay,
                                  label: Text(strings.closingDay),
                                  dropdownMenuEntries: List.generate(31, (index) => DropdownMenuEntry(value: index + 1, label: (index + 1).toString())),
                                  onSelected: (int? value) => state.creditCard.invoiceClosingDay = value ?? 0,
                                ),
                                const Spacing.x(),
                                DropdownMenu<int>(
                                  initialSelection: state.creditCard.invoiceDueDay,
                                  label: Text(strings.dueDay),
                                  dropdownMenuEntries: List.generate(31, (index) => DropdownMenuEntry(value: index + 1, label: (index + 1).toString())),
                                  onSelected: (int? value) => state.creditCard.invoiceDueDay = value ?? 0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacing.y(),
                      const Divider(),
                      GroupTile(
                        title: strings.brand,
                        onTap: selectBrand,
                        enabled: !notifier.isLoading,
                        tile: state.creditCard.brand == null
                            ? ListTile(
                                leading: const Icon(Icons.style_outlined),
                                title: Text(strings.selectBrand),
                                trailing: const Icon(Icons.chevron_right),
                                enabled: !notifier.isLoading,
                              )
                            : ListTile(
                                leading: state.creditCard.brand?.icon(),
                                title: Text(state.creditCard.brand?.description ?? ''),
                                trailing: const Icon(Icons.chevron_right),
                                enabled: !notifier.isLoading,
                              ),
                      ),
                      const Divider(),
                      GroupTile(
                        onTap: selectAccount,
                        title: strings.account,
                        enabled: !notifier.isLoading,
                        tile: state.creditCard.idAccount != null
                            ? Builder(
                                builder: (_) {
                                  final AccountEntity account = accountsNotifier.value.accounts.firstWhere((account) => account.id == state.creditCard.idAccount);
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
                ),
              );
            },
          );
        });
  }

  Future<void> save() async {
    if (notifier.isLoading) return;

    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await notifier.save();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(notifier.creditCard));
      }
    } catch (e) {
      ErrorDialog.show(context, e.toString());
    } finally {
      notifier.value = notifier.value.changedCreditCard();
    }
  }

  Future<void> delete() async {
    if (notifier.isLoading) return;

    try {
      await notifier.delete();

      if (!mounted) return;
      context.pop(FormResultNavigation<CreditCardEntity>.delete());
    } catch (e) {
      ErrorDialog.show(context, e.toString());
    } finally {
      notifier.value = notifier.value.changedCreditCard();
    }
  }

  Future<void> selectBrand() async {
    final CardBrandEnum? cardBrand = await CardBrandListBottomSheet.show(context: context, cardBrandSelected: notifier.creditCard.brand);
    if (cardBrand == null) return;

    notifier.setCardBrand(cardBrand);
  }

  Future<void> selectAccount() async {
    if (notifier.isLoading) return;

    final AccountEntity? result = await AccountsListBottomSheet.show(
      context: context,
      accountSelected: accountsNotifier.value.accounts.firstWhereOrNull((account) => account.id == notifier.creditCard.idAccount),
      accounts: accountsNotifier.value.accounts,
    );

    if (result == null) return;

    notifier.setAccount(result.id);
  }
}
