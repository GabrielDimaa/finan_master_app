import 'package:finan_master_app/features/reports/presentation/enums/date_period_enum.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/date_picker.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class DatePeriodFilter extends StatefulWidget {
  final List<DatePeriodEnum> periods;
  final void Function(DateTime? dateTimeInitial, DateTime? dateTimeFinal) onSelected;
  final DatePeriodEnum? periodSelected;
  final bool enabled;

  const DatePeriodFilter({super.key, required this.periods, required this.onSelected, this.periodSelected, this.enabled = true});

  @override
  State<DatePeriodFilter> createState() => _DatePeriodFilterState();
}

class _DatePeriodFilterState extends State<DatePeriodFilter> with ThemeContext {
  DateTime? dateTimeInitial;
  DateTime? dateTimeFinal;

  DatePeriodEnum? get periodSelected => dateTimeInitial == null || dateTimeFinal == null ? null : DatePeriodEnum.getByDateTime(dateTimeInitial!, dateTimeFinal!);

  @override
  void initState() {
    super.initState();

    final result = (widget.periodSelected ?? widget.periods.first).getDateTime();
    dateTimeInitial = result.dateTimeInitial;
    dateTimeFinal = result.dateTimeFinal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.period),
        const Spacing.y(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.periods.map((period) {
            return Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: FilterChip(
                selected: periodSelected == period,
                backgroundColor: Colors.transparent,
                label: Text(period.description),
                onSelected: widget.enabled ?(_) {
                  final result = period.getDateTime();
                  onSelect(result.dateTimeInitial, result.dateTimeFinal);
                } : null,
              ),
            );
          }).toList(),
        ),
        const Spacing.y(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          leading: const Icon(Icons.date_range_outlined, size: 18),
          title: Text(dateTimeInitial == null || dateTimeFinal == null ? strings.selectDate : '${dateTimeInitial?.format()} - ${dateTimeFinal?.format()}', style: textTheme.bodyMedium),
          trailing: Visibility(
            visible: dateTimeInitial != null || dateTimeFinal != null,
            child: IconButton(
              icon: const Icon(Icons.close_outlined, size: 20),
              onPressed: widget.enabled ? () => onSelect(null, null) : null,
            ),
          ),
          onTap: widget.enabled ? () async {
            final DateTimeRange? dateRange = await showDateRangePickerDefault(context: context);
            if (dateRange == null) return;
            onSelect(dateRange.start, dateRange.end);
          } : null,
        ),
      ],
    );
  }

  void onSelect(DateTime? dateTimeInitial, DateTime? dateTimeFinal) async {
    setState(() {
      this.dateTimeInitial = dateTimeInitial;
      this.dateTimeFinal = dateTimeFinal;
      widget.onSelected(dateTimeInitial, dateTimeFinal);
    });
  }
}
