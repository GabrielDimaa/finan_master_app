import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/monthly_filter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltersTransactions extends StatefulWidget {
  final TransactionsNotifier notifier;

  const FiltersTransactions({Key? key, required this.notifier}) : super(key: key);

  @override
  State<FiltersTransactions> createState() => _FiltersTransactionsState();
}

class _FiltersTransactionsState extends State<FiltersTransactions> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton(
          multiSelectionEnabled: false,
          segments: [
            ButtonSegment<CategoryTypeEnum?>(value: null, label: Text(AppLocalizations.of(context)!.allFilter)),
            ButtonSegment<CategoryTypeEnum>(value: CategoryTypeEnum.expense, label: Text(CategoryTypeEnum.expense.descriptionPlural)),
            ButtonSegment<CategoryTypeEnum>(value: CategoryTypeEnum.income, label: Text(CategoryTypeEnum.income.descriptionPlural)),
          ],
          selected: widget.notifier.filterType,
          onSelectionChanged: widget.notifier.filterTransactions,
        ),
        const Spacing.y(),
        MonthlyFilter(
          initialDate: widget.notifier.startDate,
          onChange: (DateTime date) => widget.notifier.findByPeriod(date.getInitialMonth(), date.getFinalMonth()),
        ),
      ],
    );
  }
}
