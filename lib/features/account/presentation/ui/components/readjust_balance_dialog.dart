import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/enums/adjustment_option_enum.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/confirm_readjust_balance_dialog.dart';
import 'package:finan_master_app/features/account/presentation/view_models/readjust_balance_view_model.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/mask/mask_input_formatter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReadjustBalance extends StatefulWidget {
  final AccountEntity account;

  const ReadjustBalance({Key? key, required this.account}) : super(key: key);

  static Future<AccountEntity?> show({required BuildContext context, required AccountEntity account}) async {
    return await showDialog<AccountEntity?>(
      context: context,
      useSafeArea: false,
      builder: (_) => ReadjustBalance(account: account),
    );
  }

  @override
  State<ReadjustBalance> createState() => _ReadjustBalanceState();
}

class _ReadjustBalanceState extends State<ReadjustBalance> with ThemeContext {
  final ReadjustBalanceViewModel viewModel = DI.get<ReadjustBalanceViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  double readjustmentValue = 0.0;
  final ValueNotifier<ReadjustmentOptionEnum> readjustmentOption = ValueNotifier(ReadjustmentOptionEnum.createTransaction);
  String? transactionDescription;

  @override
  void initState() {
    super.initState();
    viewModel.setAccount(widget.account);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: ListenableBuilder(
        listenable: Listenable.merge([viewModel, viewModel.readjustBalance]),
        builder: (_, __) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: context.pop,
                tooltip: strings.close,
                icon: const Icon(Icons.close_outlined),
              ),
              title: Text(strings.balanceReadjustment),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: TextButton(
                    onPressed: save,
                    child: Text(strings.save),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: viewModel.readjustBalance.running ? const LinearProgressIndicator() : const SizedBox(height: 4),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacing.y(2),
                      TextFormField(
                        initialValue: viewModel.account.balance.moneyWithoutSymbol,
                        decoration: InputDecoration(label: Text(strings.accountBalance), prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol),
                        validator: InputRequiredValidator().validate,
                        enabled: !viewModel.readjustBalance.running,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onSaved: (String? value) => readjustmentValue = (value ?? '').moneyToDouble(),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                      ),
                      const Spacing.y(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(strings.initialAccountBalance, style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                          Text(viewModel.account.initialAmount.money, style: textTheme.labelMedium?.copyWith(color: colorScheme.outline)),
                        ],
                      ),
                      const Spacing.y(),
                      ValueListenableBuilder(
                        valueListenable: readjustmentOption,
                        builder: (_, value, __) {
                          return Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        elevation: 0,
                                        margin: EdgeInsets.zero,
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: value == ReadjustmentOptionEnum.createTransaction ? colorScheme.primary : colorScheme.outline),
                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if (viewModel.readjustBalance.running) return;
                                            readjustmentOption.value = ReadjustmentOptionEnum.createTransaction;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(strings.createTransaction, style: textTheme.titleMedium?.copyWith(color: value == ReadjustmentOptionEnum.createTransaction ? colorScheme.primary : null)),
                                                const Spacing.y(0.5),
                                                Text(strings.createTransactionExplication, style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Card(
                                        elevation: 0,
                                        margin: EdgeInsets.zero,
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: value == ReadjustmentOptionEnum.changeInitialAmount ? colorScheme.primary : colorScheme.outline),
                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if (viewModel.readjustBalance.running) return;
                                            readjustmentOption.value = ReadjustmentOptionEnum.changeInitialAmount;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(strings.changeInitialAmount, style: textTheme.titleMedium?.copyWith(color: value == ReadjustmentOptionEnum.changeInitialAmount ? colorScheme.primary : null)),
                                                const Spacing.y(0.5),
                                                Text(strings.changeInitialAmountExplication, style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacing.y(),
                              TextFormField(
                                decoration: InputDecoration(label: Text(strings.transactionDescription)),
                                textInputAction: TextInputAction.done,
                                textCapitalization: TextCapitalization.sentences,
                                enabled: !viewModel.readjustBalance.running && readjustmentOption.value == ReadjustmentOptionEnum.createTransaction,
                                onSaved: (String? value) => transactionDescription = value,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> save() async {
    try {
      if (viewModel.readjustBalance.running) return;

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        final double difference = readjustmentValue - viewModel.account.balance;

        if (difference == 0) {
          context.pop();
          return;
        }

        final bool confirm = await ConfirmReadjustBalanceDialog.show(context: context, accountEntity: viewModel.account, value: difference, option: readjustmentOption.value);
        if (!confirm) return;

        await viewModel.readjustBalance.execute((readjustmentValue: difference, option: readjustmentOption.value, description: transactionDescription?.isNotEmpty == true ? transactionDescription! : strings.readjustmentTransaction));
        viewModel.readjustBalance.throwIfError();

        if (!mounted) return;
        context.pop(viewModel.account);
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }
}
