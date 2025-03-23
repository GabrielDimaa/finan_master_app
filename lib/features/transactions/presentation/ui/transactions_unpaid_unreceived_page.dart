import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_unpaid_unreceived_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_unpaid_unreceived_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/app_bar_custom.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/item_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_mode_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_tile_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_view_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionsUnpaidUnreceivedPage extends StatefulWidget {
  static const String route = 'transactions-unpaid-unreceived';

  final CategoryTypeEnum categoryType;

  const TransactionsUnpaidUnreceivedPage({super.key, required this.categoryType});

  @override
  State<TransactionsUnpaidUnreceivedPage> createState() => _TransactionsUnpaidUnreceivedPageState();
}

class _TransactionsUnpaidUnreceivedPageState extends State<TransactionsUnpaidUnreceivedPage> with ThemeContext {
  final TransactionsUnpaidUnreceivedNotifier notifier = DI.get<TransactionsUnpaidUnreceivedNotifier>();
  final CategoriesNotifier categoriesNotifier = DI.get<CategoriesNotifier>();
  final AccountsNotifier accountsNotifier = DI.get<AccountsNotifier>();

  List<ITransactionEntity> listSelectable = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      await Future.wait([
        categoriesNotifier.findAll(deleted: true),
        accountsNotifier.findAll(deleted: true),
      ]);

      if (categoriesNotifier is ErrorCategoriesState) {
        notifier.value = notifier.value.setError((categoriesNotifier.value as ErrorCategoriesState).message);
        return;
      }

      if (accountsNotifier is ErrorAccountsState) {
        notifier.value = notifier.value.setError((accountsNotifier.value as ErrorAccountsState).message);
        return;
      }

      await notifier.load(widget.categoryType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListModeSelectable(
      list: listSelectable,
      updateList: (List value) => setState(() => listSelectable = value.cast<ITransactionEntity>()),
      child: Scaffold(
        appBar: AppBarCustom(
          title: Text(widget.categoryType == CategoryTypeEnum.expense ? strings.payable : strings.receivable),
          actionsInModeSelection: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: deleteTransactions,
            ),
          ],
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, state, __) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: switch (state) {
                      StartTransactionsUnpaidUnreceivedState _ => const SizedBox.shrink(),
                      LoadingTransactionsUnpaidUnreceivedState _ => const Center(child: CircularProgressIndicator()),
                      ErrorTransactionsUnpaidUnreceivedState _ => MessageErrorWidget(state.message),
                      EmptyTransactionsUnpaidUnreceivedState _ => NoContentWidget(child: Text(strings.noTransactionsRegistered)),
                      ListTransactionsUnpaidUnreceivedState _ => SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacing.y(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.categoryType == CategoryTypeEnum.expense ? strings.totalPayable : strings.totalReceivable, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                        Text(notifier.totalPayableOrReceivable.abs().money, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(widget.categoryType == CategoryTypeEnum.expense ? strings.totalPaid : strings.totalReceived, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                        Text(notifier.totalPaidOrReceived.abs().money, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ListViewSelectable.separated(
                                key: ObjectKey(notifier.transactions),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                list: notifier.transactions,
                                itemBuilder: (ItemSelectable<ITransactionEntity> item) {
                                  final transaction = item.value;
                                  final category = categoriesNotifier.value.categories.firstWhere((category) => category.id == (transaction is ExpenseEntity ? transaction.idCategory : (transaction as IncomeEntity).idCategory));

                                  return ListTileSelectable(
                                    value: item,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    leading: CircleAvatar(
                                      backgroundColor: Color(category.color.toColor()!),
                                      child: Icon(category.icon.parseIconData(), color: Colors.white),
                                    ),
                                    title: Text(transaction is ExpenseEntity ? transaction.description : (transaction as IncomeEntity).description),
                                    subtitle: Text(category.description),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (notifier.isPaidOrReceived(transaction)) ...[
                                              const Icon(Icons.task_alt_outlined, size: 18, color: Color(0xFF3CDE87)),
                                            ] else ...[
                                              const Icon(Icons.push_pin_outlined, size: 18),
                                            ],
                                            const Spacing.x(0.5),
                                            Text(transaction.amount.abs().money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: transaction.amount > 0 ? const Color(0XFF3CDE87) : const Color(0XFFFF5454))),
                                          ],
                                        ),
                                        Text(transaction.date.formatDateToRelative()),
                                      ],
                                    ),
                                    onTap: () => goEdit(transaction),
                                  );
                                },
                              ),
                            ],
                          ),
                      ),
                    });
              }),
        ),
      ),
    );
  }

  Future<void> goEdit(ITransactionEntity transaction) async {
    final FormResultNavigation<ITransactionEntity>? result = await context.pushNamed(transaction is ExpenseEntity ? ExpenseFormPage.route : IncomeFormPage.route, extra: transaction);
    if (result == null) return;

    if (result.isSave) {
      notifier.setTransactions(notifier.transactions.map((e) => e.id == transaction.id ? result.value! : e).toList());
    }

    if (result.isDelete) {
      notifier.setTransactions(notifier.transactions.where((e) => e.id != transaction.id).toList());
    }
  }

  Future<void> deleteTransactions() async {
    try {
      await notifier.deleteTransactions(listSelectable);

      setState(() => listSelectable = []);
    } catch (e) {
      if (!mounted) return;
      ErrorDialog.show(context, e.toString());
    }
  }
}
