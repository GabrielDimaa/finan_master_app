import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/filters/monthly_filter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:finan_master_app/l10n/generated/app_localizations.dart';

class FiltersTransactions extends StatefulWidget {
  final TransactionsNotifier notifier;
  final bool enabled;

  const FiltersTransactions({Key? key, required this.notifier, required this.enabled}) : super(key: key);

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
            ButtonSegment<CategoryTypeEnum?>(value: null, label: Text(AppLocalizations.of(context)!.allFilter, style: const TextStyle(fontSize: 13))),
            ButtonSegment<CategoryTypeEnum>(value: CategoryTypeEnum.income, label: Text(CategoryTypeEnum.income.descriptionPlural, style: const TextStyle(fontSize: 13))),
            ButtonSegment<CategoryTypeEnum>(value: CategoryTypeEnum.expense, label: Text(CategoryTypeEnum.expense.descriptionPlural, style: const TextStyle(fontSize: 13))),
          ],
          selected: widget.notifier.filterType,
          onSelectionChanged: widget.enabled ? widget.notifier.filterTransactions : null,
        ),
        const Spacing.y(),
        MonthlyFilter(
          initialDate: widget.notifier.startDate,
          onChange: (DateTime date) => widget.notifier.findByPeriod(date.getInitialMonth(), date.getFinalMonth()),
          enabled: widget.enabled,
        ),
      ],
    );
  }
}
