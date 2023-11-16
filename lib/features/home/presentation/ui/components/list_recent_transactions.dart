import 'dart:math';

import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class ListRecentTransactions extends StatelessWidget {
  final TransactionsState state;
  final List<CategoryEntity> categories;
  final List<AccountEntity> accounts;

  const ListRecentTransactions({
    Key? key,
    required this.state,
    required this.categories,
    required this.accounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ITransactionEntity> transactions = state.transactions.where((transaction) => transaction is IncomeEntity || transaction is ExpenseEntity).toList().sublist(0, min(10, state.transactions.length));
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final ITransactionEntity entity = transactions[index];

        return switch (entity) {
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (expense.idCreditCardTransaction != null) ...[
                            const Icon(Icons.credit_card_outlined, size: 20),
                            const Spacing.x(),
                          ],
                          Text(expense.transaction.amount.money, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                        ],
                      ),
                      Text(expense.transaction.date.formatDateToRelative()),
                    ],
                  ),
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
                );
              },
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
