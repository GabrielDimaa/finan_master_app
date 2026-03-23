import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/actions_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/header_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/details/label_value_transaction_details_sheet.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transfer_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/transfer_details_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/confim_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransferDetailsSheet extends StatefulWidget {
  final String id;
  final void Function(FormResultNavigation<TransferEntity>)? onChanged;

  const TransferDetailsSheet._({required this.id, this.onChanged});

  static Future<void> show({required BuildContext context, required String id, void Function(FormResultNavigation<TransferEntity>)? onChanged}) async {
    return await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => TransferDetailsSheet._(id: id, onChanged: onChanged),
    );
  }

  @override
  State<TransferDetailsSheet> createState() => _TransferDetailsSheetState();
}

class _TransferDetailsSheetState extends State<TransferDetailsSheet> with ThemeContext {
  final TransferDetailsViewModel viewModel = DI.get<TransferDetailsViewModel>();

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
                            description: strings.transfer,
                            amount: viewModel.transfer.amount,
                            amountColor: colorScheme.onSurface,
                            iconAvatar: Icons.move_up_outlined,
                            backgroundColorAvatar: colorScheme.secondaryContainer,
                            onBackgroundColorAvatar: Colors.white,
                          ),
                          const Spacing.y(1.5),
                          ActionsTransactionDetailsSheet(
                            onEditPressed: goFormsPage,
                            onDeletePressed: delete,
                          ),
                        ],
                      ),
                    ),
                    const Spacing.y(),
                    const Divider(),
                    const Spacing.y(),
                    IntrinsicWidth(
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 100),
                                child: Card(
                                  color: colorScheme.surfaceContainer,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 10,
                                      children: [
                                        viewModel.accountFrom.financialInstitution!.icon(32),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          spacing: 2,
                                          children: [
                                            Text(
                                              viewModel.accountFrom.description,
                                              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              strings.source,
                                              style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: colorScheme.secondaryContainer.withAlpha(70),
                              child: Icon(Icons.arrow_forward, color: colorScheme.onSecondaryContainer, size: 20),
                            ),
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 100),
                                child: Card(
                                  color: colorScheme.surfaceContainer,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 10,
                                      children: [
                                        viewModel.accountTo.financialInstitution!.icon(32),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          spacing: 2,
                                          children: [
                                            Text(
                                              viewModel.accountTo.description,
                                              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              strings.destination,
                                              style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                value: viewModel.transfer.date.formatDateToRelative(),
                              ),
                              LabelValueTransactionDetailsSheet(
                                label: strings.type,
                                value: strings.transfer,
                                crossAxisAlignment: CrossAxisAlignment.end,
                              ),
                            ],
                          ),
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
    final FormResultNavigation<TransferEntity>? result = await context.pushNamed(TransferFormPage.route, extra: viewModel.transfer);

    if (result?.isSave == true) {
      widget.onChanged?.call(result!);
      viewModel.load.execute(result!.value!.id);
    }
  }

  Future<void> delete() async {
    try {
      final bool confirm = await ConfirmDialog.show(context: context, title: strings.deleteCardExpense, message: strings.deleteCardExpenseConfirmation);
      if (!confirm) return;

      await viewModel.delete.execute(viewModel.transfer);
      viewModel.delete.throwIfError();

      widget.onChanged?.call(FormResultNavigation<TransferEntity>.delete());

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }
}
