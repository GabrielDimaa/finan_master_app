import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transfer_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/item_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_tile_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_view_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ListTransactions extends StatefulWidget {
  final TransactionsState state;
  final List<CategoryEntity> categories;
  final List<AccountEntity> accounts;
  final VoidCallback refreshTransactions;

  const ListTransactions({
    Key? key,
    required this.state,
    required this.categories,
    required this.accounts,
    required this.refreshTransactions,
  }) : super(key: key);

  @override
  State<ListTransactions> createState() => _ListTransactionsState();
}

class _ListTransactionsState extends State<ListTransactions> {
  @override
  Widget build(BuildContext context) {
    return ListViewSelectable.separated(
      key: ObjectKey(widget.state),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 50),
      list: widget.state.transactions,
      itemBuilder: (ItemSelectable<ITransactionEntity> item) {
        if (item.value is ExpenseEntity) {
          final expense = item.value as ExpenseEntity;
          final category = widget.categories.firstWhere((category) => category.id == expense.idCategory);
          return ListTileSelectable<ITransactionEntity>(
            value: item,
            leading: CircleAvatar(
              backgroundColor: Color(category.color.toColor()!),
              child: Icon(category.icon.parseIconData(), color: Colors.white),
            ),
            title: Text(expense.description),
            subtitle: Text(category.description),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (expense.idCreditCard != null) ...[
                      const Icon(Icons.credit_card_outlined, size: 20),
                      const Spacing.x(),
                    ],
                    Text(expense.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                  ],
                ),
                Text(expense.date.formatDateToRelative()),
              ],
            ),
            onTap: () async {
              try {
                if (expense.idCreditCard != null) throw Exception(R.strings.notPossibleEditTransactionCreditCardPaid);
                await goFormsPage(context: context, route: ExpenseFormPage.route, entity: expense);
              } catch (e) {
                if (!context.mounted) return;
                ErrorDialog.show(context, e.toString());
              }
            },
          );
        }

        if (item.value is IncomeEntity) {
          final income = item.value as IncomeEntity;
          final category = widget.categories.firstWhere((category) => category.id == income.idCategory);
          return ListTileSelectable<ITransactionEntity>(
            value: item,
            leading: CircleAvatar(
              backgroundColor: Color(category.color.toColor()!),
              child: Icon(category.icon.parseIconData(), color: Colors.white),
            ),
            title: Text(income.description),
            subtitle: Text(category.description),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(income.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFF3CDE87))),
                Text(income.date.formatDateToRelative()),
              ],
            ),
            onTap: () => goFormsPage(context: context, route: IncomeFormPage.route, entity: income),
          );
        }

        if (item.value is TransferEntity) {
          final transfer = item.value as TransferEntity;
          return Column(
            children: [
              ListTileSelectable<ITransactionEntity>(
                value: item,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  child: const Icon(Icons.move_up_outlined),
                ),
                title: Text(AppLocalizations.of(context)!.transfer),
                subtitle: Builder(
                  builder: (_) {
                    final AccountEntity account = widget.accounts.firstWhere((account) => account.id == transfer.idAccountTo);
                    return Text(account.description);
                  },
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(transfer.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0xFF3CDE87))),
                    Text(transfer.date.formatDateToRelative()),
                  ],
                ),
                onTap: () => goFormsPage(context: context, route: TransferFormPage.route, entity: transfer),
              ),
              const Divider(),
              ListTileSelectable<ITransactionEntity>(
                value: item,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  child: const Icon(Icons.move_up_outlined),
                ),
                title: Text(AppLocalizations.of(context)!.transfer),
                subtitle: Builder(
                  builder: (_) {
                    final AccountEntity account = widget.accounts.firstWhere((account) => account.id == transfer.idAccountFrom);
                    return Text(account.description);
                  },
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(transfer.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0xFFFF5454))),
                    Text(transfer.date.formatDateToRelative()),
                  ],
                ),
                onTap: () => goFormsPage(context: context, route: TransferFormPage.route, entity: transfer),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> goFormsPage({required BuildContext context, required String route, required ITransactionEntity entity}) async {
    final FormResultNavigation? result = await context.pushNamed(route, extra: entity);
    if (result == null) return;

    widget.refreshTransactions();
  }
}
