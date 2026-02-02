import 'dart:math';

import 'package:collection/collection.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/accounts_list_bottom_sheet.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/presentation/ui/components/categories_list_bottom_sheet.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/income_form_view_model.dart';
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
  final IncomeFormViewModel viewModel = DI.get<IncomeFormViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController observationController = TextEditingController();

  final FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        await viewModel.init.execute(widget.income);
        viewModel.init.throwIfError();

        amountController.text = viewModel.income.amount.abs().moneyWithoutSymbol;
        descriptionController.text = viewModel.income.description;
        dateController.text = viewModel.income.date.format();
        observationController.text = viewModel.income.observation ?? '';
      } catch (e) {
        if (!mounted) return;
        ErrorDialog.show(context, e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([viewModel.save, viewModel.delete]),
      builder: (_, __) {
        return SliverScaffold(
          appBar: SliverAppBarMedium(
            title: Text(strings.income),
            loading: viewModel.isLoading,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
              if (widget.income?.isNew == false)
                IconButton(
                  tooltip: strings.delete,
                  onPressed: delete,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          body: ListenableBuilder(
            listenable: Listenable.merge([viewModel, viewModel.init]),
            builder: (_, __) {
              if (viewModel.init.running) return const SizedBox.shrink();

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
                            controller: amountController,
                            decoration: InputDecoration(
                              label: Text(strings.amount),
                              prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                            ),
                            validator: InputValidators([InputRequiredValidator(), InputGreaterThanValueValidator(0)]).validate,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            enabled: !viewModel.isLoading,
                            onSaved: (String? value) => viewModel.income.amount = (value ?? '').moneyToDouble(),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                          ),
                          const Spacing.y(),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Autocomplete<TransactionByTextEntity>(
                                textEditingController: descriptionController,
                                focusNode: descriptionFocusNode,
                                displayStringForOption: (TransactionByTextEntity option) => option.description,
                                fieldViewBuilder: (_, textController, focusNode, ___) {
                                  return TextFormField(
                                    decoration: InputDecoration(label: Text(strings.description)),
                                    textCapitalization: TextCapitalization.sentences,
                                    controller: textController,
                                    focusNode: focusNode,
                                    validator: InputRequiredValidator().validate,
                                    onSaved: (String? value) => viewModel.income.description = value?.trim() ?? '',
                                    enabled: !viewModel.isLoading,
                                  );
                                },
                                optionsBuilder: (TextEditingValue textEditingValue) async {
                                  if (textEditingValue.text.length <= 1) return [];

                                  await viewModel.findByText.execute(textEditingValue.text);
                                  viewModel.findByText.throwIfError();

                                  return viewModel.findByText.result ?? [];
                                },
                                onSelected: (TransactionByTextEntity selection) {
                                  viewModel.setIdCategory(selection.idCategory);
                                  if (selection.idAccount != null && viewModel.accounts.any((c) => c.id == selection.idAccount && c.deletedAt == null)) viewModel.setIdAccount(selection.idAccount!);
                                  viewModel.income.observation = selection.observation;
                                  observationController.text = selection.observation ?? '';
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
                                            final category = viewModel.categories.firstWhereOrNull((category) => category.id == income.idCategory);
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
                            enabled: !viewModel.isLoading,
                            onTap: selectDate,
                          ),
                        ],
                      ),
                    ),
                    const Spacing.y(),
                    const Divider(),
                    ListTile(
                      leading: viewModel.income.received ? const Icon(Icons.task_alt_outlined) : const Icon(Icons.push_pin_outlined),
                      title: Text(viewModel.income.received ? strings.received : strings.unReceived),
                      trailing: Switch(value: viewModel.income.received, onChanged: viewModel.setReceived),
                      onTap: () => viewModel.setReceived(!viewModel.income.received),
                    ),
                    const Divider(),
                    GroupTile(
                      onTap: selectCategory,
                      title: strings.category,
                      enabled: !viewModel.isLoading,
                      tile: viewModel.income.idCategory != null
                          ? Builder(
                              builder: (_) {
                                final CategoryEntity category = viewModel.categories.firstWhere((category) => category.id == viewModel.income.idCategory);
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Color(category.color.toColor() ?? 0),
                                    child: Icon(category.icon.parseIconData(), color: Colors.white),
                                  ),
                                  title: Text(category.description),
                                  trailing: const Icon(Icons.chevron_right),
                                  enabled: !viewModel.isLoading,
                                );
                              },
                            )
                          : ListTile(
                              leading: const Icon(Icons.category_outlined),
                              title: Text(strings.selectCategory),
                              trailing: const Icon(Icons.chevron_right),
                              enabled: !viewModel.isLoading,
                            ),
                    ),
                    const Divider(),
                    GroupTile(
                      onTap: selectAccount,
                      title: strings.account,
                      enabled: !viewModel.isLoading,
                      tile: viewModel.income.idAccount != null
                          ? Builder(
                              builder: (_) {
                                final AccountEntity account = viewModel.accounts.firstWhere((account) => account.id == viewModel.income.idAccount);
                                return ListTile(
                                  leading: account.financialInstitution!.icon(),
                                  title: Text(account.description),
                                  trailing: const Icon(Icons.chevron_right),
                                  enabled: !viewModel.isLoading,
                                );
                              },
                            )
                          : ListTile(
                              leading: const Icon(Icons.account_balance_outlined),
                              title: Text(strings.selectAccount),
                              trailing: const Icon(Icons.chevron_right),
                              enabled: !viewModel.isLoading,
                            ),
                    ),
                    const Divider(),
                    const Spacing.y(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: observationController,
                        decoration: InputDecoration(label: Text("${strings.observation} (${strings.optional})")),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 2,
                        maxLines: 5,
                        onSaved: (String? value) => viewModel.income.observation = value?.trim() ?? '',
                        enabled: !viewModel.isLoading,
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
  }

  Future<void> save() async {
    if (viewModel.isLoading) return;

    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await viewModel.save.execute(viewModel.income);
        viewModel.save.throwIfError();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(viewModel.income));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (viewModel.isLoading) return;

    try {
      await viewModel.delete.execute(viewModel.income);
      viewModel.delete.throwIfError();

      if (!mounted) return;
      context.pop(FormResultNavigation<IncomeEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectCategory() async {
    if (viewModel.isLoading) return;

    final CategoryEntity? result = await CategoriesListBottomSheet.show(
      context: context,
      categorySelected: viewModel.categories.firstWhereOrNull((category) => category.id == viewModel.income.idCategory),
      categories: viewModel.categories.where((category) => category.deletedAt == null).toList(),
      onCategoryCreated: (CategoryEntity category) => viewModel.categories.add(category),
    );

    if (result == null) return;

    viewModel.setIdCategory(result.id);
  }

  Future<void> selectAccount() async {
    if (viewModel.isLoading) return;

    final AccountEntity? result = await AccountsListBottomSheet.show(
      context: context,
      accountSelected: viewModel.accounts.firstWhereOrNull((account) => account.id == viewModel.income.idAccount),
      accounts: viewModel.accounts.where((account) => account.deletedAt == null).toList(),
      onAccountCreated: (AccountEntity account) => viewModel.accounts.add(account),
    );

    if (result == null) return;

    viewModel.setIdAccount(result.id);
  }

  Future<void> selectDate() async {
    if (viewModel.isLoading) return;

    final DateTime? result = await showDatePickerDefault(
      context: context,
      initialDate: viewModel.income.date,
    );

    if (result == null || result == viewModel.income.date) return;

    if (result.isAfter(DateTime.now()) && viewModel.income.date.isBefore(DateTime.now())) viewModel.setReceived(false);

    dateController.text = result.format();
    viewModel.setDate(result);
  }
}
