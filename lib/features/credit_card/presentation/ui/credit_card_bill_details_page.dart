import 'dart:math';

import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/pay_bill_dialog.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/view_models/credit_card_bill_details_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/loading_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/item_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_mode_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_tile_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_view_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar_medium.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreditCardBillDetailsArgsPage {
  final CreditCardBillEntity bill;
  final CreditCardEntity creditCard;

  CreditCardBillDetailsArgsPage({required this.bill, required this.creditCard});
}

class CreditCardBillDetailsPage extends StatefulWidget {
  static const String route = 'credit-card-bill-details';

  final CreditCardBillDetailsArgsPage args;

  const CreditCardBillDetailsPage({super.key, required this.args});

  @override
  State<CreditCardBillDetailsPage> createState() => _CreditCardBillDetailsPageState();
}

class _CreditCardBillDetailsPageState extends State<CreditCardBillDetailsPage> with ThemeContext {
  final CreditCardBillDetailsViewModel viewModel = DI.get<CreditCardBillDetailsViewModel>();

  List<CreditCardTransactionEntity> listSelectable = [];

  bool changed = false;

  @override
  void initState() {
    super.initState();

    viewModel.load.execute(widget.args.bill);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // canPop: false,
      // onPopInvoked: (_) => context.pop(changed ? FormResultNavigation.save(notifier.creditCardBill!) : null),
      onWillPop: () async {
        if (changed) context.pop(FormResultNavigation.save(viewModel.bill));
        return true;
      },
      child: ListModeSelectable(
        list: listSelectable,
        updateList: (List value) => setState(() => listSelectable = value.cast<CreditCardTransactionEntity>()),
        child: Scaffold(
          body: SafeArea(
            child: ListenableBuilder(
              listenable: Listenable.merge([viewModel, viewModel.load, viewModel.refreshBill]),
              builder: (_, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBarMedium(
                            title: Text(strings.bill),
                            actionsInModeSelection: [
                              IconButton(
                                tooltip: strings.delete,
                                onPressed: deleteTransactions,
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                          if (viewModel.load.running || viewModel.refreshBill.running) ...[
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ] else if (viewModel.load.hasError || viewModel.refreshBill.hasError) ...[
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: MessageErrorWidget(viewModel.load.error?.toString() ?? viewModel.refreshBill.error.toString()),
                            ),
                          ] else ...[
                            SliverToBoxAdapter(
                              child: Builder(builder: (_) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Spacing.y(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                  color: viewModel.bill.status.color,
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(viewModel.bill.status.description, style: textTheme.bodyLarge),
                                            ],
                                          ),
                                          const Spacing.y(1.5),
                                          Text(widget.args.creditCard.description, style: textTheme.bodyLarge),
                                          const Spacing.y(0.5),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(strings.closureDate, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                                  Text(viewModel.bill.billClosingDate.format(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(strings.dueDate, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                                  Text(viewModel.bill.billDueDate.format(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacing.y(2),
                                          if (viewModel.bill.transactions.isNotEmpty) Text(strings.transactions, style: textTheme.bodyLarge),
                                        ],
                                      ),
                                    ),
                                    ListViewSelectable.separated(
                                      key: ObjectKey(viewModel.bill.transactions),
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      list: viewModel.bill.transactions,
                                      itemBuilder: (ItemSelectable<CreditCardTransactionEntity> item) {
                                        final transaction = item.value;
                                        final category = viewModel.categories.firstWhere((category) => category.id == transaction.idCategory);

                                        return ListTileSelectable(
                                          value: item,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                          leading: CircleAvatar(
                                            backgroundColor: Color(category.color.toColor()!),
                                            child: Icon(category.icon.parseIconData(), color: Colors.white),
                                          ),
                                          title: Text(transaction.description),
                                          subtitle: Text(category.description),
                                          trailing: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                transaction.amount.money,
                                                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: transaction.amount < 0 ? const Color(0XFF3CDE87) : null),
                                              ),
                                              Text(transaction.date.formatDateToRelative()),
                                            ],
                                          ),
                                          onTap: () => goCreditCardExpenseForm(transaction),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (listSelectable.isEmpty && !viewModel.load.running && !viewModel.refreshBill.running && !viewModel.load.hasError && !viewModel.refreshBill.hasError)
                      Padding(
                        padding: const EdgeInsets.all(16).copyWith(top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Card(
                              color: colorScheme.surfaceContainer,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(strings.totalSpent, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                          Text(viewModel.bill.totalSpent.money, style: textTheme.titleMedium?.copyWith(fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30, child: VerticalDivider()),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(strings.amountOutstanding, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                          Text(max(viewModel.bill.billAmount, 0.0).money, style: textTheme.titleMedium?.copyWith(fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacing.y(1.5),
                            FilledButton.icon(
                              onPressed: viewModel.bill.totalSpent > 0 && viewModel.bill.billAmount > 0 ? payBill : null,
                              icon: const Icon(Icons.credit_score_outlined),
                              label: Text(strings.payBill),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> goCreditCardExpenseForm(CreditCardTransactionEntity entity) async {
    if (entity.amount < 0) return;

    final FormResultNavigation<CreditCardTransactionEntity>? result = await context.pushNamed(CreditCardExpensePage.route, extra: entity);
    if (result != null) {
      changed = true;
      await viewModel.refreshBill.execute();
    }
  }

  Future<void> payBill() async {
    final CreditCardBillEntity? result = await PayBillDialog.show(context: context, bill: viewModel.bill);

    if (result != null) {
      changed = true;
      await viewModel.refreshBill.execute();
    }
  }

  Future<void> deleteTransactions() async {
    await LoadingDialog.show(context: context, message: strings.deletingTransactions, onAction: () => viewModel.deleteTransactions.execute(listSelectable));
    viewModel.deleteTransactions.throwIfError();

    setState(() {
      changed = true;
      listSelectable = [];
    });
    await viewModel.refreshBill.execute();
  }
}
