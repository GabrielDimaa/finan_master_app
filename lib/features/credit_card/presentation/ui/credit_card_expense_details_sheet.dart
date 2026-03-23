import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/actions_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/header_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/label_value_transaction_details_sheet.dart';
import 'package:finan_master_app/features/credit_card/presentation/view_models/credit_card_expense_details_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/confim_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreditCardExpenseDetailsSheet extends StatefulWidget {
  final String id;
  final void Function(FormResultNavigation<CreditCardTransactionEntity>)? onChanged;

  const CreditCardExpenseDetailsSheet._({required this.id, this.onChanged});

  static Future<void> show({required BuildContext context, required String id, void Function(FormResultNavigation<CreditCardTransactionEntity>)? onChanged}) async {
    return await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => CreditCardExpenseDetailsSheet._(id: id, onChanged: onChanged),
    );
  }

  @override
  State<CreditCardExpenseDetailsSheet> createState() => _CreditCardExpenseDetailsSheetState();
}

class _CreditCardExpenseDetailsSheetState extends State<CreditCardExpenseDetailsSheet> with ThemeContext {
  final CreditCardExpenseDetailsViewModel viewModel = DI.get<CreditCardExpenseDetailsViewModel>();

  @override
  void initState() {
    viewModel.load.execute(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([viewModel, viewModel.load]),
      builder: (_, __) {
        return DraggableBottomSheet(
          initialChildSize: 0.7,
          builder: (scrollController) {
            if (viewModel.load.running) return const Center(child: CircularProgressIndicator());
            if (viewModel.load.hasError) return MessageErrorWidget(viewModel.load.error.toString());

            if (viewModel.load.completed) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          HeaderTransactionDetailsSheet(
                            description: viewModel.creditCardExpense.description,
                            amount: viewModel.creditCardExpense.amount,
                            amountColor: viewModel.creditCardExpense.amount > 0 ? colorScheme.onSurface : const Color(0XFF3CDE87),
                            iconAvatar: viewModel.category.icon.parseIconData(),
                            backgroundColorAvatar: Color(viewModel.category.color.toColor()!),
                            onBackgroundColorAvatar: Colors.white,
                            financialInstitution: viewModel.creditCardCard.financialInstitutionAccount,
                          ),
                          const Spacing.y(1.5),
                          ActionsTransactionDetailsSheet(
                            onEditPressed: viewModel.creditCardExpense.amount > 0 ? goFormsPage : null,
                            onDeletePressed: delete,
                          ),
                        ],
                      ),
                    ),
                    const Spacing.y(),
                    const Divider(),
                    const Spacing.y(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LabelValueTransactionDetailsSheet(
                                label: strings.date,
                                value: viewModel.creditCardExpense.date.formatDateToRelative(),
                              ),
                              LabelValueTransactionDetailsSheet(
                                label: strings.creditCard,
                                value: viewModel.creditCardCard.description,
                                crossAxisAlignment: CrossAxisAlignment.end,
                              ),
                            ],
                          ),
                          const Spacing.y(1.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LabelValueTransactionDetailsSheet(
                                label: strings.category,
                                value: viewModel.category.description,
                              ),
                              LabelValueTransactionDetailsSheet(
                                label: strings.type,
                                value: viewModel.creditCardExpense.amount > 0 ? strings.cardExpense : strings.billPayment,
                                crossAxisAlignment: CrossAxisAlignment.end,
                              ),
                            ],
                          ),
                          const Spacing.y(1.5),
                          if (viewModel.creditCardExpense.observation?.isNotEmpty == true) ...[
                            LabelValueTransactionDetailsSheet(
                              label: strings.observation,
                              value: viewModel.creditCardExpense.observation!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Future<void> goFormsPage() async {
    final FormResultNavigation<CreditCardTransactionEntity>? result = await context.pushNamed(CreditCardExpenseFormPage.route, extra: viewModel.creditCardExpense);

    if (result?.isSave == true) {
      widget.onChanged?.call(result!);
      viewModel.load.execute(result!.value!.id);
    }
  }

  Future<void> delete() async {
    try {
      final bool confirm = await ConfirmDialog.show(
        context: context,
        title: viewModel.creditCardExpense.amount > 0 ? strings.deleteCardExpense : strings.deleteBillPayment,
        message: viewModel.creditCardExpense.amount > 0 ? strings.deleteCardExpenseConfirmation : strings.deleteBillPaymentConfirmation,
      );

      if (!confirm) return;

      await viewModel.delete.execute(viewModel.creditCardExpense);
      viewModel.delete.throwIfError();

      widget.onChanged?.call(FormResultNavigation<CreditCardTransactionEntity>.delete());

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }
}
