import 'package:collection/collection.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/accounts_list_bottom_sheet.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/card_brand_list_bottom_sheet.dart';
import 'package:finan_master_app/features/credit_card/presentation/view_models/credit_card_form_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
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

class CreditCardFormPage extends StatefulWidget {
  static const route = 'credit-card-form';

  final CreditCardEntity? creditCard;

  const CreditCardFormPage({Key? key, this.creditCard}) : super(key: key);

  @override
  State<CreditCardFormPage> createState() => _CreditCardFormPageState();
}

class _CreditCardFormPageState extends State<CreditCardFormPage> with ThemeContext {
  final CreditCardFormViewModel viewModel = DI.get<CreditCardFormViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        await viewModel.load.execute(widget.creditCard);
        viewModel.load.throwIfError();
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
            title: Text(strings.creditCard),
            loading: viewModel.save.running || viewModel.delete.running,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
              if (widget.creditCard != null)
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
                            initialValue: viewModel.creditCard.description,
                            decoration: InputDecoration(label: Text(strings.description)),
                            validator: InputRequiredValidator().validate,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            enabled: !viewModel.isLoading,
                            onSaved: (String? value) => viewModel.creditCard.description = value ?? '',
                          ),
                          const Spacing.y(),
                          TextFormField(
                            initialValue: viewModel.creditCard.amountLimit.moneyWithoutSymbol,
                            decoration: InputDecoration(
                              label: Text(strings.limit),
                              prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                            ),
                            validator: InputValidators([InputRequiredValidator(), InputGreaterThanValueValidator(0)]).validate,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            enabled: !viewModel.isLoading,
                            onSaved: (String? value) => viewModel.creditCard.amountLimit = (value ?? '').moneyToDouble(),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                          ),
                          const Spacing.y(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: DropdownMenu<int>(
                                  initialSelection: viewModel.creditCard.billClosingDay,
                                  enabled: !viewModel.isLoading,
                                  label: Text(strings.closingDay),
                                  dropdownMenuEntries: List.generate(30, (index) => DropdownMenuEntry(value: index + 1, label: (index + 1).toString())),
                                  onSelected: (int? value) => viewModel.creditCard.billClosingDay = value ?? 0,
                                ),
                              ),
                              const Spacing.x(),
                              Expanded(
                                child: DropdownMenu<int>(
                                  initialSelection: viewModel.creditCard.billDueDay,
                                  enabled: !viewModel.isLoading,
                                  label: Text(strings.dueDay),
                                  dropdownMenuEntries: List.generate(30, (index) => DropdownMenuEntry(value: index + 1, label: (index + 1).toString())),
                                  onSelected: (int? value) => viewModel.creditCard.billDueDay = value ?? 0,
                                ),
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
                      enabled: !viewModel.isLoading,
                      tile: viewModel.creditCard.brand == null
                          ? ListTile(
                              leading: const Icon(Icons.style_outlined),
                              title: Text(strings.selectBrand),
                              trailing: const Icon(Icons.chevron_right),
                              enabled: !viewModel.isLoading,
                            )
                          : ListTile(
                              leading: viewModel.creditCard.brand?.icon(),
                              title: Text(viewModel.creditCard.brand?.description ?? ''),
                              trailing: const Icon(Icons.chevron_right),
                              enabled: !viewModel.isLoading,
                            ),
                    ),
                    const Divider(),
                    GroupTile(
                      onTap: selectAccount,
                      title: strings.account,
                      enabled: !viewModel.isLoading,
                      tile: viewModel.creditCard.idAccount != null
                          ? Builder(
                              builder: (_) {
                                final AccountEntity account = viewModel.accounts.firstWhere((account) => account.id == viewModel.creditCard.idAccount);
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

        await viewModel.save.execute(viewModel.creditCard);
        viewModel.save.throwIfError();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(viewModel.creditCard));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (viewModel.isLoading) return;

    try {
      await viewModel.delete.execute(viewModel.creditCard);
      viewModel.delete.throwIfError();

      if (!mounted) return;
      context.pop(FormResultNavigation<CreditCardEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectBrand() async {
    final CardBrandEnum? cardBrand = await CardBrandListBottomSheet.show(context: context, cardBrandSelected: viewModel.creditCard.brand);
    if (cardBrand == null) return;

    viewModel.setCardBrand(cardBrand);
  }

  Future<void> selectAccount() async {
    if (viewModel.isLoading) return;

    final AccountEntity? result = await AccountsListBottomSheet.show(
      context: context,
      accountSelected: viewModel.accounts.firstWhereOrNull((account) => account.id == viewModel.creditCard.idAccount),
      accounts: viewModel.accounts.where((account) => account.financialInstitution != FinancialInstitutionEnum.wallet && account.deletedAt == null).toList(),
      onAccountCreated: (AccountEntity account) => viewModel.setAccounts([...viewModel.accounts, account]),
    );

    if (result == null) return;

    viewModel.setAccount(result);
  }
}
