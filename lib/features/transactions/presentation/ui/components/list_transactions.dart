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
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ListTransactions extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, __) => const Divider(),
      itemCount: state.transactions.length,
      itemBuilder: (_, index) {
        final ITransactionEntity transaction = state.transactions[index];

        return Column(
          children: [
            switch (transaction) {
              ExpenseEntity expense => Builder(
                  builder: (_) {
                    final category = categories.firstWhere((category) => category.id == expense.idCategory);
                    return ListTile(
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
                          Text(expense.transaction.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                          Text(expense.transaction.date.formatDateToRelative()),
                        ],
                      ),
                      onTap: () => goFormsPage(context: context, route: ExpenseFormPage.route, entity: expense),
                    );
                  },
                ),
              IncomeEntity income => Builder(
                  builder: (_) {
                    final category = categories.firstWhere((category) => category.id == income.idCategory);
                    return ListTile(
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
                          Text(income.transaction.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFF3CDE87))),
                          Text(income.transaction.date.formatDateToRelative()),
                        ],
                      ),
                      onTap: () => goFormsPage(context: context, route: IncomeFormPage.route, entity: income),
                    );
                  },
                ),
              TransferEntity transfer => Builder(
                  builder: (_) {
                    final account = accounts.firstWhere((account) => account.id == transfer.idAccount);
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            child: const Icon(Icons.move_up_outlined),
                          ),
                          title: Text(AppLocalizations.of(context)!.transfer),
                          subtitle: Text(account.description),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(transfer.transactionTo.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFF3CDE87))),
                              Text(transfer.transactionTo.date.formatDateToRelative()),
                            ],
                          ),
                          onTap: () => goFormsPage(context: context, route: TransferFormPage.route, entity: transfer),
                        ),
                        const Divider(),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            child: const Icon(Icons.move_up_outlined),
                          ),
                          title: Text(AppLocalizations.of(context)!.transfer),
                          subtitle: Text(account.description),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(transfer.transactionFrom.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                              Text(transfer.transactionFrom.date.formatDateToRelative()),
                            ],
                          ),
                          onTap: () => goFormsPage(context: context, route: TransferFormPage.route, entity: transfer),
                        ),
                      ],
                    );
                  },
                ),
              _ => const SizedBox.shrink(),
            },
            if (index == state.transactions.length - 1) const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  Future<void> goFormsPage({required BuildContext context, required String route, required ITransactionEntity entity}) async {
    final FormResultNavigation? result = await context.pushNamed(route, extra: entity);
    if (result != null) refreshTransactions();
  }
}
