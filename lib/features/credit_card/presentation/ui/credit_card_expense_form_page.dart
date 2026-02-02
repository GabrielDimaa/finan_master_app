import 'dart:math';

import 'package:collection/collection.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/presentation/ui/components/categories_list_bottom_sheet.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/credit_cards_list_bottom_sheet.dart';
import 'package:finan_master_app/features/credit_card/presentation/view_models/credit_card_expense_form_view_model.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';
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

class CreditCardExpensePage extends StatefulWidget {
  final CreditCardTransactionEntity? creditCardExpense;

  static const route = 'credit-card-expense-form';

  const CreditCardExpensePage({Key? key, this.creditCardExpense}) : super(key: key);

  @override
  State<CreditCardExpensePage> createState() => _CreditCardExpensePageState();
}

class _CreditCardExpensePageState extends State<CreditCardExpensePage> with ThemeContext {
  final CreditCardExpenseFormViewModel viewModel = DI.get<CreditCardExpenseFormViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  TextEditingValue textEditingValue = const TextEditingValue(text: '');

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        await viewModel.load.execute(widget.creditCardExpense);
        viewModel.load.throwIfError();

        dateController.text = viewModel.creditCardExpense.date.format();
        textEditingValue = TextEditingValue(text: viewModel.creditCardExpense.description);
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
            title: Text(strings.cardExpense),
            loading: viewModel.isLoading,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
              if (widget.creditCardExpense != null)
                IconButton(
                  tooltip: strings.delete,
                  onPressed: delete,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          body: ListenableBuilder(
            listenable: Listenable.merge([viewModel, viewModel.load]),
            builder: (_, __) {
              if (viewModel.load.running) return const SizedBox.shrink();

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
                            initialValue: viewModel.creditCardExpense.amount.moneyWithoutSymbol,
                            decoration: InputDecoration(
                              label: Text(strings.amount),
                              prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                            ),
                            validator: InputValidators([InputRequiredValidator(), InputGreaterThanValueValidator(0)]).validate,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            enabled: !viewModel.isLoading,
                            onSaved: (String? value) => viewModel.creditCardExpense.amount = (value ?? '').moneyToDouble(),
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
                                    onSaved: (String? value) => viewModel.creditCardExpense.description = value?.trim() ?? '',
                                    enabled: !viewModel.isLoading,
                                  );
                                },
                                optionsBuilder: (TextEditingValue textEditingValue) async {
                                  if (textEditingValue.text.length <= 1) {
                                    this.textEditingValue = textEditingValue;
                                    return [];
                                  }

                                  if (textEditingValue.text == this.textEditingValue.text) return [];

                                  await viewModel.findByText.execute(textEditingValue.text);
                                  viewModel.findByText.throwIfError();

                                  this.textEditingValue = textEditingValue;
                                  return viewModel.findByText.result ?? [];
                                },
                                onSelected: (TransactionByTextEntity selection) {
                                  viewModel.setCategory(selection.idCategory);
                                  viewModel.creditCardExpense.observation = selection.observation;
                                },
                                optionsViewBuilder: (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 12,
                                      color: colorScheme.surfaceContainerHighest,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0))),
                                      child: SizedBox(
                                        height: min(160, 80.0 * options.length),
                                        width: constraints.biggest.width,
                                        child: ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: options.length,
                                          itemBuilder: (_, index) {
                                            final TransactionByTextEntity expense = options.elementAt(index);
                                            final category = viewModel.categories.firstWhereOrNull((category) => category.id == expense.idCategory);
                                            if (category == null) return const SizedBox.shrink();

                                            return ListTile(
                                              dense: true,
                                              leading: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Color(category.color.toColor()!),
                                                child: Icon(category.icon.parseIconData(), color: Colors.white),
                                              ),
                                              title: Text(expense.description),
                                              subtitle: Text(category.description),
                                              onTap: () => onSelected(expense),
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
                    GroupTile(
                      onTap: selectCategory,
                      title: strings.category,
                      enabled: !viewModel.isLoading,
                      tile: viewModel.creditCardExpense.idCategory != null
                          ? Builder(
                              builder: (_) {
                                final CategoryEntity category = viewModel.categories.firstWhere((category) => category.id == viewModel.creditCardExpense.idCategory);
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
                      onTap: selectCreditCard,
                      title: strings.creditCard,
                      enabled: !viewModel.isLoading,
                      tile: viewModel.creditCardExpense.idCreditCard != null
                          ? Builder(
                              builder: (_) {
                                final CreditCardEntity creditCard = viewModel.creditCards.firstWhere((creditCard) => creditCard.id == viewModel.creditCardExpense.idCreditCard);
                                return ListTile(
                                  leading: const Icon(Icons.credit_card_outlined),
                                  title: Text(creditCard.description),
                                  trailing: const Icon(Icons.chevron_right),
                                  enabled: !viewModel.isLoading,
                                );
                              },
                            )
                          : ListTile(
                              leading: const Icon(Icons.credit_card_outlined),
                              title: Text(strings.selectCreditCard),
                              trailing: const Icon(Icons.chevron_right),
                              enabled: !viewModel.isLoading,
                            ),
                    ),
                    const Divider(),
                    const Spacing.y(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        initialValue: viewModel.creditCardExpense.observation,
                        decoration: InputDecoration(label: Text("${strings.observation} (${strings.optional})")),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 2,
                        maxLines: 5,
                        onSaved: (String? value) => viewModel.creditCardExpense.observation = value?.trim() ?? '',
                        enabled: !viewModel.isLoading,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    );
  }

  Future<void> save() async {
    if (viewModel.isLoading) return;

    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await viewModel.save.execute(viewModel.creditCardExpense);
        viewModel.save.throwIfError();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(viewModel.creditCardExpense));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (viewModel.isLoading) return;

    try {
      await viewModel.delete.execute(viewModel.creditCardExpense);
      viewModel.delete.throwIfError();

      if (!mounted) return;
      context.pop(FormResultNavigation<CreditCardTransactionEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectCategory() async {
    if (viewModel.isLoading) return;

    final CategoryEntity? result = await CategoriesListBottomSheet.show(
      context: context,
      categorySelected: viewModel.categories.firstWhereOrNull((category) => category.id == viewModel.creditCardExpense.idCategory),
      categories: viewModel.categories.where((category) => category.deletedAt == null).toList(),
      onCategoryCreated: (CategoryEntity category) => viewModel.setCategories([...viewModel.categories, category]),
    );

    if (result == null) return;

    viewModel.setCategory(result.id);
  }

  Future<void> selectCreditCard() async {
    if (viewModel.isLoading) return;

    final CreditCardEntity? result = await CreditCardsListBottomSheet.show(
      context: context,
      creditCardSelected: viewModel.creditCards.firstWhereOrNull((creditCard) => creditCard.id == viewModel.creditCardExpense.idCreditCard),
      creditCards: viewModel.creditCards.where((creditCard) => creditCard.deletedAt == null).toList(),
      onCreditCardCreated: (CreditCardEntity creditCard) => viewModel.setCreditCards([...viewModel.creditCards, creditCard]),
    );

    if (result == null) return;

    viewModel.setCreditCard(result.id);
  }

  Future<void> selectDate() async {
    if (viewModel.isLoading) return;

    final DateTime? result = await showDatePickerDefault(context: context, initialDate: viewModel.creditCardExpense.date);

    if (result == null || result == viewModel.creditCardExpense.date) return;

    dateController.text = result.format();
    viewModel.setDate(result);
  }
}
