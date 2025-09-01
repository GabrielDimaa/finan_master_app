import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/presentation/view_models/pay_bill_view_model.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/mask/mask_input_formatter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_greater_than_value_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_validators.dart';
import 'package:finan_master_app/shared/presentation/ui/components/linear_progress_indicator_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PayBillDialog extends StatefulWidget {
  final CreditCardBillEntity bill;

  const PayBillDialog({Key? key, required this.bill}) : super(key: key);

  static Future<CreditCardBillEntity?> show({required BuildContext context, required CreditCardBillEntity bill}) async {
    return await showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => PayBillDialog(bill: bill),
    );
  }

  @override
  State<PayBillDialog> createState() => _PayBillDialogState();
}

class _PayBillDialogState extends State<PayBillDialog> with ThemeContext {
  final PayBillViewModel viewModel = DI.get<PayBillViewModel>();

  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.load(widget.bill.clone());

    textController.text = 0.0.moneyWithoutSymbol;

    textController.addListener(() {
      viewModel.setPayValue(textController.text.moneyToDouble());
    });
  }

  AppBar get appBar => AppBar(
        leading: IconButton(
          onPressed: context.pop,
          tooltip: strings.close,
          icon: const Icon(Icons.close_outlined),
        ),
        title: Text(strings.payBill),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: TextButton(
              onPressed: viewModel.payValue > 0 ? save : null,
              child: Text(strings.save),
            ),
          ),
        ],
        bottom: LinearProgressIndicatorAppBar(show: viewModel.save.running),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: appBar.preferredSize,
          child: ListenableBuilder(
            listenable: Listenable.merge([viewModel, viewModel.save]),
            builder: (_, __) => appBar,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacing.y(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
                        text: '${strings.openBillAmount} ',
                      ),
                      TextSpan(
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.primary),
                        text: viewModel.bill.billAmount.money,
                        recognizer: TapGestureRecognizer()..onTap = () => !viewModel.save.running ? textController.text = viewModel.bill.billAmount.moneyWithoutSymbol : null,
                      ),
                    ],
                  ),
                ),
                const Spacing.y(),
                ListenableBuilder(
                  listenable: viewModel.save,
                  builder: (_, __) {
                    return TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autofocus: true,
                      decoration: InputDecoration(label: Text(strings.value), prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol),
                      controller: textController,
                      validator: InputValidators([InputRequiredValidator(), InputGreaterThanValueValidator(0)]).validate,
                      enabled: !viewModel.save.running,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> save() async {
    try {
      await viewModel.save.execute();
      viewModel.save.throwIfError();

      if (!mounted) return;
      context.pop(viewModel.bill);
    } catch (e) {
      if (!mounted) return;
      ErrorDialog.show(context, e.toString());
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
