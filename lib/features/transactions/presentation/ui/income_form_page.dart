import 'dart:math';

import 'package:collection/collection.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/accounts_list_bottom_sheet.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/category/presentation/ui/components/categories_list_bottom_sheet.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/income_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/states/income_state.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/date_picker.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/mask/mask_input_formatter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_greater_than_value_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_validators.dart';
import 'package:finan_master_app/shared/presentation/ui/components/group_tile.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar_medium.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class IncomeFormPage extends StatefulWidget {
  static const route = 'income-form';

  final IncomeEntity? income;

  const IncomeFormPage({Key? key, this.income}) : super(key: key);

  @override
  State<IncomeFormPage> createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends State<IncomeFormPage> with ThemeContext {
  final IncomeNotifier notifier = DI.get<IncomeNotifier>();
  final CategoriesNotifier categoriesNotifier = DI.get<CategoriesNotifier>();
  final AccountsNotifier accountsNotifier = DI.get<AccountsNotifier>();

  final ValueNotifier<bool> initialLoadingNotifier = ValueNotifier(true);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();

  List<TransactionByTextEntity> transactionsOldAutoComplete = [];
  late TextEditingValue textEditingValue;

  @override
  void initState() {
    super.initState();

    dateController.text = notifier.income.date.format();

    Future(() async {
      try {
        await Future.wait([
          categoriesNotifier.findAll(type: CategoryTypeEnum.income, deleted: true),
          accountsNotifier.findAll(deleted: true),
        ]);

        if (categoriesNotifier.value is ErrorCategoriesState) throw Exception((categoriesNotifier.value as ErrorCategoriesState).message);
        if (accountsNotifier.value is ErrorAccountsState) throw Exception((accountsNotifier.value as ErrorAccountsState).message);

        if (widget.income != null) {
          notifier.setIncome(widget.income!);
        } else {
          final AccountEntity? account = accountsNotifier.value.accounts.where((account) => account.deletedAt == null).singleOrNull;
          if (account != null) notifier.setAccount(account.id);
        }

        textEditingValue = TextEditingValue(text: notifier.income.description);
        dateController.text = notifier.income.date.format();
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
      builder: (_, initialLoading, __) {
        return ValueListenableBuilder(
          valueListenable: notifier,
          builder: (_, state, __) {
            return SliverScaffold(
              appBar: SliverAppBarMedium(
                title: Text(strings.income),
                loading: notifier.isLoading,
                actions: [
                  FilledButton(
                    onPressed: save,
                    child: Text(strings.save),
                  ),
                  if (!state.income.isNew)
                    IconButton(
                      tooltip: strings.delete,
                      onPressed: delete,
                      icon: const Icon(Icons.delete_outline),
                    ),
                ],
              ),
              body: Builder(
                builder: (_) {
                  if (initialLoading) return const SizedBox.shrink();

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
                                initialValue: state.income.amount.abs().moneyWithoutSymbol,
                                decoration: InputDecoration(
                                  label: Text(strings.amount),
                                  prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                                ),
                                validator: InputValidators([InputRequiredValidator(), InputGreaterThanValueValidator(0)]).validate,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                enabled: !notifier.isLoading,
                                onSaved: (String? value) => state.income.amount = (value ?? '').moneyToDouble(),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                              ),
                              const Spacing.y(),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Autocomplete<TransactionByTextEntity>(
                                    initialValue: textEditingValue,
                                    displayStringForOption: (TransactionByTextEntity option) => option.description,
                                    fieldViewBuilder: (_, textController, focusNode, ___) {
                                      return TextFormField(
                                        decoration: InputDecoration(label: Text(strings.description)),
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: textController,
                                        focusNode: focusNode,
                                        validator: InputRequiredValidator().validate,
                                        onSaved: (String? value) => state.income.description = value?.trim() ?? '',
                                        enabled: !notifier.isLoading,
                                      );
                                    },
                                    optionsBuilder: (TextEditingValue textEditingValue) async {
                                      if (textEditingValue.text.length <= 1) {
                                        this.textEditingValue = textEditingValue;
                                        return [];
                                      }

                                      if (textEditingValue.text == this.textEditingValue.text) return [];

                                      transactionsOldAutoComplete = await notifier.findByText(textEditingValue.text);
                                      this.textEditingValue = textEditingValue;
                                      return transactionsOldAutoComplete;
                                    },
                                    onSelected: (TransactionByTextEntity selection) {
                                      notifier.setCategory(selection.idCategory);
                                      if (selection.idAccount != null && accountsNotifier.value.accounts.any((c) => c.id == selection.idAccount && c.deletedAt == null)) notifier.setAccount(selection.idAccount!);
                                      notifier.income.observation = selection.observation;
                                    },
                                    optionsViewBuilder: (context, onSelected, options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 12,
                                          color: colorScheme.surface,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0))),
                                          child: SizedBox(
                                            height: min(160, 80.0 * options.length),
                                            width: constraints.biggest.width,
                                            child: ListView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: options.length,
                                              itemBuilder: (_, index) {
                                                final TransactionByTextEntity income = options.elementAt(index);
                                                final category = categoriesNotifier.value.categories.firstWhereOrNull((category) => category.id == income.idCategory);
                                                if (category == null) return const SizedBox.shrink();

                                                return ListTile(
                                                  dense: true,
                                                  leading: CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Color(category.color.toColor()!),
                                                    child: Icon(category.icon.parseIconData(), color: Colors.white),
                                                  ),
                                                  title: Text(income.description),
                                                  subtitle: Text(category.description),
                                                  onTap: () => onSelected(income),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
                          onTap: selectCategory,
                          title: strings.category,
                          enabled: !notifier.isLoading,
                          tile: state.income.idCategory != null
                              ? Builder(
                                  builder: (_) {
                                    final CategoryEntity category = categoriesNotifier.value.categories.firstWhere((category) => category.id == state.income.idCategory);
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Color(category.color.toColor() ?? 0),
                                        child: Icon(category.icon.parseIconData(), color: Colors.white),
                                      ),
                                      title: Text(category.description),
                                      trailing: const Icon(Icons.chevron_right),
                                      enabled: !notifier.isLoading,
                                    );
                                  },
                                )
                              : ListTile(
                                  leading: const Icon(Icons.category_outlined),
                                  title: Text(strings.selectCategory),
                                  trailing: const Icon(Icons.chevron_right),
                                  enabled: !notifier.isLoading,
                                ),
                        ),
                        const Divider(),
                        GroupTile(
                          onTap: selectAccount,
                          title: strings.account,
                          enabled: !notifier.isLoading,
                          tile: state.income.idAccount != null
                              ? Builder(
                                  builder: (_) {
                                    final AccountEntity account = accountsNotifier.value.accounts.firstWhere((account) => account.id == state.income.idAccount);
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
                        const Spacing.y(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            initialValue: state.income.observation,
                            decoration: InputDecoration(label: Text("${strings.observation} (${strings.optional})")),
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 2,
                            maxLines: 5,
                            onSaved: (String? value) => state.income.observation = value?.trim() ?? '',
                            enabled: !notifier.isLoading,
                          ),
                        ),
                      ],
                    ),
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
        if (notifier.value is ErrorIncomeState) throw Exception((notifier.value as ErrorIncomeState).message);

        if (!mounted) return;
        context.pop(FormResultNavigation.save(notifier.income));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    try {
      await notifier.delete();
      if (notifier.value is ErrorIncomeState) throw Exception((notifier.value as ErrorIncomeState).message);

      if (!mounted) return;
      context.pop(FormResultNavigation<IncomeEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectCategory() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    final CategoryEntity? result = await CategoriesListBottomSheet.show(
      context: context,
      categorySelected: categoriesNotifier.value.categories.firstWhereOrNull((category) => category.id == notifier.income.idCategory),
      categories: categoriesNotifier.value.categories.where((category) => category.deletedAt == null).toList(),
      onCategoryCreated: (CategoryEntity category) => categoriesNotifier.value.categories.add(category),
    );

    if (result == null) return;

    notifier.setCategory(result.id);
  }

  Future<void> selectAccount() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    final AccountEntity? result = await AccountsListBottomSheet.show(
      context: context,
      accountSelected: accountsNotifier.value.accounts.firstWhereOrNull((account) => account.id == notifier.income.idAccount),
      accounts: accountsNotifier.value.accounts.where((account) => account.deletedAt == null).toList(),
      onAccountCreated: (AccountEntity account) => accountsNotifier.value.accounts.add(account),
    );

    if (result == null) return;

    notifier.setAccount(result.id);
  }

  Future<void> selectDate() async {
    if (initialLoadingNotifier.value || notifier.isLoading) return;

    final DateTime? result = await showDatePickerDefault(
      context: context,
      initialDate: notifier.income.date,
    );

    if (result == null || result == notifier.income.date) return;

    dateController.text = result.format();
    notifier.setDate(result);
  }
}
