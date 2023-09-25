import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FiltersTransactions extends StatefulWidget {
  final TransactionsNotifier notifier;

  const FiltersTransactions({Key? key, required this.notifier}) : super(key: key);

  @override
  State<FiltersTransactions> createState() => _FiltersTransactionsState();
}

class _FiltersTransactionsState extends State<FiltersTransactions> with ThemeContext {
  late final DateTime dateNow;
  late DateTime dateFiltered;

  @override
  void initState() {
    super.initState();

    dateNow = DateTime.now();
    dateFiltered = dateNow;
  }

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
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: strings.previous,
              icon: const Icon(Icons.chevron_left_outlined),
              onPressed: () => changeDateFiltered(dateFiltered.subtractMonth(1)),
            ),
            const Spacing.x(4),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 70),
              child: Column(
                children: [
                  Text(DateFormat('MMMM', strings.localeName).format(dateFiltered).toString()),
                  if (dateFiltered.year != dateNow.year) Text(dateFiltered.year.toString(), style: textTheme.labelSmall),
                ],
              ),
            ),
            const Spacing.x(4),
            IconButton(
              tooltip: strings.next,
              icon: const Icon(Icons.chevron_right_outlined),
              onPressed: () => changeDateFiltered(dateFiltered.addMonth(1)),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> changeDateFiltered(DateTime date) async {
    setState(() => dateFiltered = date);

    await widget.notifier.findByPeriod(
      DateTime(date.year, date.month, 1),
      DateTime(date.year, date.month, date.getLastDayInMonth(), 23, 59, 59, 59),
    );
  }
}
