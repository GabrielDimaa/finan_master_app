import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/actions_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/header_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/label_value_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/income_details_view_model.dart';
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

class IncomeDetailsSheet extends StatefulWidget {
  final String id;
  final void Function(FormResultNavigation<IncomeEntity>)? onChanged;

  const IncomeDetailsSheet._({required this.id, this.onChanged});

  static Future<void> show({required BuildContext context, required String id, void Function(FormResultNavigation<IncomeEntity>)? onChanged}) async {
    return await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => IncomeDetailsSheet._(id: id, onChanged: onChanged),
    );
  }

  @override
  State<IncomeDetailsSheet> createState() => _IncomeDetailsSheetState();
}

class _IncomeDetailsSheetState extends State<IncomeDetailsSheet> with ThemeContext {
  final IncomeDetailsViewModel viewModel = DI.get<IncomeDetailsViewModel>();

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
                            description: viewModel.income.description,
                            amount: viewModel.income.amount,
                            iconAvatar: viewModel.category.icon.parseIconData(),
                            backgroundColorAvatar: Color(viewModel.category.color.toColor()!),
                            onBackgroundColorAvatar: Colors.white,
                            financialInstitution: viewModel.account.financialInstitution,
                          ),
                          const Spacing.y(1.5),
                          ActionsTransactionDetailsSheet(
                            onEditPressed: goFormsPage,
                            onDeletePressed: delete,
                            children: [
                              ListenableBuilder(
                                listenable: viewModel.saveReceived,
                                builder: (_, __) {
                                  return FilledButton.icon(
                                    label: Text(viewModel.income.received ? strings.undoReceipt : strings.markAsReceived),
                                    icon: viewModel.saveReceived.running ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2.5)) : Icon(viewModel.income.received ? Icons.push_pin_outlined : Icons.task_alt_outlined),
                                    style: viewModel.income.received ? null : FilledButton.styleFrom(backgroundColor: colorScheme.surfaceDim, foregroundColor: colorScheme.onSurface),
                                    onPressed: () => viewModel.saveReceived.execute(!viewModel.income.received).then((_) => widget.onChanged?.call(FormResultNavigation.save(viewModel.income))),
                                  );
                                },
                              ),
                            ],
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
                                value: viewModel.income.date.formatDateToRelative(),
                              ),
                              LabelValueTransactionDetailsSheet(
                                label: strings.account,
                                value: viewModel.account.description,
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
                                value: strings.income,
                                crossAxisAlignment: CrossAxisAlignment.end,
                              ),
                            ],
                          ),
                          const Spacing.y(1.5),
                          if (viewModel.income.observation?.isNotEmpty == true) ...[
                            LabelValueTransactionDetailsSheet(
                              label: strings.observation,
                              value: viewModel.income.observation!,
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
    final FormResultNavigation<IncomeEntity>? result = await context.pushNamed(IncomeFormPage.route, extra: viewModel.income);

    if (result?.isSave == true) {
      widget.onChanged?.call(result!);
      viewModel.load.execute(result!.value!.id);
    }
  }

  Future<void> delete() async {
    try {
      final bool confirm = await ConfirmDialog.show(context: context, title: strings.deleteIncome, message: strings.deleteIncomeConfirmation);
      if (!confirm) return;

      await viewModel.delete.execute(viewModel.income);
      viewModel.delete.throwIfError();

      widget.onChanged?.call(FormResultNavigation<IncomeEntity>.delete());

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }
}
