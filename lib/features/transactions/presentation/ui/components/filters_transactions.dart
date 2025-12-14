import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/transactions_list_view_model.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/filters/monthly_filter.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:finan_master_app/l10n/generated/app_localizations.dart';

class FiltersTransactions extends StatefulWidget {
  final TransactionsListViewModel viewModel;
  final bool enabled;

  const FiltersTransactions({Key? key, required this.viewModel, required this.enabled}) : super(key: key);

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
          selected: widget.viewModel.filterType,
          onSelectionChanged: widget.enabled ? widget.viewModel.setFilterType : null,
        ),
        const Spacing.y(),
        ListenableBuilder(
          listenable: widget.viewModel,
          builder: (_, __) {
            return MonthlyFilter(
              key: ValueKey(widget.viewModel.startDate),
              initialDate: widget.viewModel.startDate,
              onChange: (DateTime date) => widget.viewModel.findByPeriod.execute((startDate: date.getInitialMonth(), endDate: date.getFinalMonth())),
              enabled: widget.enabled,
            );
          }
        ),
      ],
    );
  }
}
