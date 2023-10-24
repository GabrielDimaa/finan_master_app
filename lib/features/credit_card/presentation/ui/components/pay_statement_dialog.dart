import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_statement_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_statement_state.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/mask/mask_input_formatter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_greater_than_value.dart';
import 'package:finan_master_app/shared/presentation/ui/components/linear_progress_indicator_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PayStatementDialog extends StatefulWidget {
  final CreditCardStatementEntity statement;

  const PayStatementDialog({Key? key, required this.statement}) : super(key: key);

  static Future<void> show({required BuildContext context, required CreditCardStatementEntity statement}) async {
    await showDialog(
      context: context,
      builder: (_) => PayStatementDialog(statement: statement),
    );
  }

  @override
  State<PayStatementDialog> createState() => _PayStatementDialogState();
}

class _PayStatementDialogState extends State<PayStatementDialog> with ThemeContext {
  final CreditCardStatementNotifier notifier = GetIt.I.get<CreditCardStatementNotifier>();

  final TextEditingController textController = TextEditingController();

  double payValue = 0;

  bool get isLoading => notifier.value is SavingCreditCardStatementState;

  @override
  void initState() {
    super.initState();
    notifier.setStatement(widget.statement);

    textController.text = notifier.creditCardStatement!.statementAmount.moneyWithoutSymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: ValueListenableBuilder(
        valueListenable: notifier,
        builder: (_, state, __) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: context.pop,
                tooltip: strings.close,
                icon: const Icon(Icons.close_outlined),
              ),
              title: Text(strings.payStatement),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: TextButton(
                    onPressed: payValue > 0 ? save : null,
                    child: Text(strings.save),
                  ),
                ),
              ],
              bottom: isLoading ? const LinearProgressIndicatorAppBar() : null,
            ),
            body: SingleChildScrollView(
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
                          text: '${strings.openStatementAmount} ',
                        ),
                        TextSpan(
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.primary),
                          text: notifier.creditCardStatement!.statementAmount.money,
                          recognizer: TapGestureRecognizer()..onTap = () => textController.text = notifier.creditCardStatement!.statementAmount.moneyWithoutSymbol,
                        ),
                      ],
                    ),
                  ),
                  const Spacing.y(),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    autofocus: true,
                    decoration: InputDecoration(label: Text(strings.accountBalance), prefixText: NumberFormat.simpleCurrency(locale: R.locale.toString()).currencySymbol),
                    controller: textController,
                    validator: InputGreaterThanValueValidator().validate,
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (String value) {
                      setState(() => payValue = value.moneyToDouble());
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, MaskInputFormatter.currency()],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> save() async {
    try {
      await notifier.payStatement(payValue);
    } catch (e) {
      if (!mounted) return;
      ErrorDialog.show(context, e.toString());
    }
  }
}
