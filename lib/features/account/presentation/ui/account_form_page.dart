import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/financial_institutions.dart';
import 'package:finan_master_app/features/account/presentation/view_models/account_form_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/mask/mask_input_formatter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/group_tile.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar_medium.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AccountFormPage extends StatefulWidget {
  static const route = 'account-form';

  final AccountEntity? account;

  const AccountFormPage({Key? key, this.account}) : super(key: key);

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> with ThemeContext {
  final AccountFormViewModel viewModel = DI.get<AccountFormViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.account != null) viewModel.load(widget.account!.clone());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([viewModel.save, viewModel.delete]),
      builder: (_, __) {
        final bool running = viewModel.save.running || viewModel.delete.running;

        return SliverScaffold(
          appBar: SliverAppBarMedium(
            title: Text(strings.account),
            loading: running,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
              if (!viewModel.account.isNew)
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
                  child: TextFormField(
                    initialValue: viewModel.account.initialAmount.moneyWithoutSymbol,
                    decoration: InputDecoration(
                      label: Text(strings.initialAmount),
                      prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol,
                    ),
                    validator: InputRequiredValidator().validate,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    enabled: !running && viewModel.account.isNew,
                    onSaved: (String? value) => viewModel.account.initialAmount = (value ?? '').moneyToDouble(),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                  ),
                ),
                const Spacing.y(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    initialValue: viewModel.account.description,
                    decoration: InputDecoration(label: Text(strings.description)),
                    textCapitalization: TextCapitalization.sentences,
                    validator: InputRequiredValidator().validate,
                    textInputAction: TextInputAction.done,
                    enabled: !running,
                    onSaved: (String? value) => viewModel.account.description = value?.trim() ?? '',
                  ),
                ),
                const Spacing.y(),
                const Divider(),
                ListenableBuilder(
                    listenable: viewModel,
                    builder: (_, __) {
                      return Column(
                        children: [
                          GroupTile(
                            title: strings.financialInstitution,
                            onTap: selectFinancialInstitution,
                            enabled: !running,
                            tile: viewModel.account.financialInstitution == null
                                ? ListTile(
                                    leading: const Icon(Icons.account_balance_outlined),
                                    title: Text(strings.selectFinancialInstitution),
                                    trailing: const Icon(Icons.chevron_right),
                                    enabled: !running,
                                  )
                                : ListTile(
                                    leading: viewModel.account.financialInstitution?.icon(),
                                    title: Text(viewModel.account.financialInstitution?.description ?? ''),
                                    trailing: const Icon(Icons.chevron_right),
                                    enabled: !running,
                                  ),
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: Text(strings.includeTotalBalance),
                            subtitle: Text(strings.includeTotalBalanceExplication),
                            value: viewModel.account.includeTotalBalance,
                            onChanged: running ? null : viewModel.setIncludeTotalBalance,
                          ),
                        ],
                      );
                    }),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> save() async {
    if (viewModel.save.running || viewModel.delete.running) return;

    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await viewModel.save.execute(viewModel.account);
        viewModel.save.throwIfError();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(viewModel.account));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (viewModel.save.running || viewModel.delete.running) return;

    try {
      await viewModel.delete.execute(viewModel.account);
      viewModel.delete.throwIfError();

      if (!mounted) return;
      context.pop(FormResultNavigation<AccountEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectFinancialInstitution() async {
    final FinancialInstitutionEnum? financialInstitution = await FinancialInstitutions.show(context: context, financialInstitution: viewModel.account.financialInstitution);
    if (financialInstitution == null) return;

    viewModel.setFinancialInstitution(financialInstitution);
  }
}
