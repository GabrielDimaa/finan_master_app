import 'package:collection/collection.dart';
import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/accounts_list_bottom_sheet.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/transfer_form_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
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

class TransferFormPage extends StatefulWidget {
  static const route = 'transfer-form';

  final TransferEntity? transfer;

  const TransferFormPage({Key? key, this.transfer}) : super(key: key);

  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> with ThemeContext {
  final TransferFormViewModel viewModel = DI.get<TransferFormViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        await viewModel.init.execute(widget.transfer);
        viewModel.init.throwIfError();

        amountTextController.text = viewModel.transfer.amount.abs().moneyWithoutSymbol;
        dateTextController.text = viewModel.transfer.date.format();
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
            title: Text(strings.transfer),
            loading: viewModel.isLoading,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
              if (widget.transfer?.isNew == false)
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
                            decoration: InputDecoration(
                              label: Text(strings.amount),
                              prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                            ),
                            validator: InputValidators([InputRequiredValidator(), InputGreaterThanValueValidator(0)]).validate,
                            controller: amountTextController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            enabled: !viewModel.isLoading,
                            onSaved: (String? value) => viewModel.transfer.amount = (value ?? '').moneyToDouble(),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                          ),
                          const Spacing.y(),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.calendar_today_outlined),
                              label: Text(strings.date),
                            ),
                            readOnly: true,
                            controller: dateTextController,
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
                      onTap: selectAccountFrom,
                      title: strings.from,
                      enabled: !viewModel.isLoading,
                      tile: viewModel.transfer.idAccountFrom != null
                          ? Builder(
                              builder: (_) {
                                final AccountEntity account = viewModel.accounts.firstWhere((account) => account.id == viewModel.transfer.idAccountFrom);
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
                    GroupTile(
                      onTap: selectAccountTo,
                      title: strings.to,
                      enabled: !viewModel.isLoading,
                      tile: viewModel.transfer.idAccountTo != null
                          ? Builder(
                              builder: (_) {
                                final AccountEntity account = viewModel.accounts.firstWhere((account) => account.id == viewModel.transfer.idAccountTo);
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

        await viewModel.save.execute(viewModel.transfer);
        viewModel.delete.throwIfError();

        if (!mounted) return;
        context.pop(FormResultNavigation<TransferEntity>.save(viewModel.transfer));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (viewModel.isLoading) return;

    try {
      await viewModel.delete.execute(viewModel.transfer);
      viewModel.delete.throwIfError();

      if (!mounted) return;
      context.pop(FormResultNavigation<TransferEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectAccountFrom() async {
    if (viewModel.init.running) return;

    final AccountEntity? result = await showAccountListBottomSheet(viewModel.transfer.idAccountFrom);
    if (result == null) return;

    viewModel.setAccountFrom(result.id);
  }

  Future<void> selectAccountTo() async {
    if (viewModel.init.running) return;

    final AccountEntity? result = await showAccountListBottomSheet(viewModel.transfer.idAccountTo);
    if (result == null) return;

    viewModel.setAccountTo(result.id);
  }

  Future<AccountEntity?> showAccountListBottomSheet(String? idAccount) async {
    return await AccountsListBottomSheet.show(
      context: context,
      accountSelected: viewModel.accounts.firstWhereOrNull((account) => account.id == idAccount),
      accounts: viewModel.accounts.where((account) => account.deletedAt == null).toList(),
      onAccountCreated: (AccountEntity account) => viewModel.accounts.add(account),
    );
  }

  Future<void> selectDate() async {
    if (viewModel.init.running) return;

    final DateTime? result = await showDatePickerDefault(context: context, initialDate: viewModel.transfer.date);

    if (result == null || result == viewModel.transfer.date) return;

    dateTextController.text = result.format();
    viewModel.setDate(result);
  }
}
