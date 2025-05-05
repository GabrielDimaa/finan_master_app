import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:flutter/material.dart';
import 'package:finan_master_app/l10n/generated/app_localizations.dart';

class TotalsTransactions extends StatelessWidget {
  final TransactionsNotifier notifier;

  const TotalsTransactions({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (notifier.filterType.firstOrNull == CategoryTypeEnum.expense) {
      return _total(
        context: context,
        label: AppLocalizations.of(context)!.monthlyExpense,
        value: notifier.transactionsByPeriod.amountsExpense,
      );
    }

    if (notifier.filterType.firstOrNull == CategoryTypeEnum.income) {
      return _total(
        context: context,
        label: AppLocalizations.of(context)!.monthlyIncome,
        value: notifier.transactionsByPeriod.amountsIncome,
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        _total(
          context: context,
          label: AppLocalizations.of(context)!.monthlyBalanceCumulative,
          value: notifier.monthlyBalanceCumulative,
        ),
        _total(
          context: context,
          label: AppLocalizations.of(context)!.monthlyBalance,
          value: notifier.transactionsByPeriod.balance,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }

  Widget _total({
    required BuildContext context,
    required String label,
    required double value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value.money, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
