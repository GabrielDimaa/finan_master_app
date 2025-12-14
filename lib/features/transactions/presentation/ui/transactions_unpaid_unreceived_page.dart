import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/transactions_unpaid_unreceived_view_model.dart';
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
  final TransactionsUnpaidUnreceivedViewModel viewModel = DI.get<TransactionsUnpaidUnreceivedViewModel>();

  List<ITransactionEntity> listSelectable = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      await viewModel.init.execute(widget.categoryType);
      viewModel.init.throwIfError();
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
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (_, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: () {
                  if (viewModel.init.running) return const Center(child: CircularProgressIndicator());
                  if (viewModel.init.hasError) return MessageErrorWidget(viewModel.init.error.toString());
                  if (viewModel.transactions.isEmpty) return NoContentWidget(child: Text(strings.noTransactionsRegistered));

                  return SingleChildScrollView(
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
                                  Text(viewModel.totalPayableOrReceivable.abs().money, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(widget.categoryType == CategoryTypeEnum.expense ? strings.totalPaid : strings.totalReceived, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                  Text(viewModel.totalPaidOrReceived.abs().money, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListViewSelectable.separated(
                          key: ObjectKey(viewModel.transactions),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          list: viewModel.transactions,
                          itemBuilder: (ItemSelectable<ITransactionEntity> item) {
                            final transaction = item.value;
                            final category = viewModel.categories.firstWhere((category) => category.id == (transaction is ExpenseEntity ? transaction.idCategory : (transaction as IncomeEntity).idCategory));

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
                                      if (viewModel.isPaidOrReceived(transaction)) ...[
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
                  );
                }(),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> goEdit(ITransactionEntity transaction) async {
    final FormResultNavigation<ITransactionEntity>? result = await context.pushNamed(transaction is ExpenseEntity ? ExpenseFormPage.route : IncomeFormPage.route, extra: transaction);
    if (result == null) return;

    if (result.isSave) {
      viewModel.setTransactions(viewModel.transactions.map((e) => e.id == transaction.id ? result.value! : e).toList());
    }

    if (result.isDelete) {
      viewModel.setTransactions(viewModel.transactions.where((e) => e.id != transaction.id).toList());
    }
  }

  Future<void> deleteTransactions() async {
    try {
      await viewModel.deleteTransactions(listSelectable);

      setState(() => listSelectable = []);
    } catch (e) {
      if (!mounted) return;
      ErrorDialog.show(context, e.toString());
    }
  }
}
