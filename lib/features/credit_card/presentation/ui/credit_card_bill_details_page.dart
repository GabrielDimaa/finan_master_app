import 'dart:math';

import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_bill_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/components/pay_bill_dialog.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
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
  final CreditCardBillNotifier notifier = DI.get<CreditCardBillNotifier>();
  final CategoriesNotifier categoriesNotifier = DI.get<CategoriesNotifier>();

  List<CreditCardTransactionEntity> listSelectable = [];

  bool changed = false;

  @override
  void initState() {
    super.initState();

    notifier.setBill(widget.args.bill);

    Future(() async {
      try {
        await categoriesNotifier.findAll(deleted: true);

        if (categoriesNotifier.value is ErrorCategoriesState) throw Exception((categoriesNotifier.value as ErrorCategoriesState).message);
      } catch (e) {
        if (!mounted) return;
        ErrorDialog.show(context, e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // canPop: false,
      // onPopInvoked: (_) => context.pop(changed ? FormResultNavigation.save(notifier.creditCardBill!) : null),
      onWillPop: () async {
        if (changed) context.pop(FormResultNavigation.save(notifier.creditCardBill!));
        return true;
      },
      child: ListModeSelectable(
        list: listSelectable,
        updateList: (List value) => setState(() => listSelectable = value.cast<CreditCardTransactionEntity>()),
        child: Scaffold(
          body: ValueListenableBuilder(
            valueListenable: categoriesNotifier,
            builder: (_, categoriesState, __) {
              return switch (categoriesState) {
                LoadingCategoriesState _ => const Center(child: CircularProgressIndicator()),
                StartCategoriesState _ => const SizedBox.shrink(),
                ErrorCategoriesState error => MessageErrorWidget(error.message),
                ListCategoriesState _ || EmptyCategoriesState _ => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverAppBarMedium(
                              title: Text(strings.bill),
                              loading: notifier.isLoading,
                              actionsInModeSelection: [
                                IconButton(
                                  tooltip: strings.delete,
                                  onPressed: deleteTransactions,
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                            SliverToBoxAdapter(
                              child: Column(
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
                                                color: notifier.creditCardBill!.status.color,
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(notifier.creditCardBill!.status.description, style: textTheme.bodyLarge),
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
                                                Text(notifier.creditCardBill!.billClosingDate.format(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(strings.dueDate, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                                Text(notifier.creditCardBill!.billDueDate.format(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Spacing.y(2),
                                        if (notifier.creditCardBill!.transactions.isNotEmpty) Text(strings.transactions, style: textTheme.bodyLarge),
                                      ],
                                    ),
                                  ),
                                  ListViewSelectable.separated(
                                    key: ObjectKey(notifier.creditCardBill!.transactions),
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    list: notifier.creditCardBill!.transactions,
                                    itemBuilder: (ItemSelectable<CreditCardTransactionEntity> item) {
                                      final transaction = item.value;
                                      final category = categoriesNotifier.value.categories.firstWhere((category) => category.id == transaction.idCategory);

                                      return ListTileSelectable(
                                        value: item,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (listSelectable.isEmpty)
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
                                            Text(notifier.creditCardBill!.totalSpent.money, style: textTheme.titleMedium?.copyWith(fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 30, child: VerticalDivider()),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(strings.amountOutstanding, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                            Text(max(notifier.creditCardBill!.billAmount, 0.0).money, style: textTheme.titleMedium?.copyWith(fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacing.y(1.5),
                              FilledButton.icon(
                                onPressed: (notifier.creditCardBill?.totalSpent ?? 0) > 0 && (notifier.creditCardBill?.billAmount ?? 0) > 0 ? payBill : null,
                                icon: const Icon(Icons.credit_score_outlined),
                                label: Text(strings.payBill),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              };
            },
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
      await refreshBill();
    }
  }

  Future<void> payBill() async {
    final CreditCardBillEntity? result = await PayBillDialog.show(context: context, bill: notifier.creditCardBill!);

    if (result != null) {
      changed = true;
      await refreshBill();
    }
  }

  Future<void> deleteTransactions() async {
    await LoadingDialog.show(context: context, message: strings.deletingTransactions, onAction: () => notifier.deleteTransactions(listSelectable));

    changed = true;
    listSelectable = [];
    refreshBill();
  }

  Future<void> refreshBill() async {
    await notifier.findById(notifier.creditCardBill!.id);
    setState(() {});
  }
}
