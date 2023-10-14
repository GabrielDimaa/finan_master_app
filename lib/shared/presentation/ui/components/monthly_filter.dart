import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyFilter extends StatefulWidget {
  final DateTime startDate;
  final void Function(DateTime date) onChange;

  const MonthlyFilter({Key? key, required this.startDate, required this.onChange}) : super(key: key);

  @override
  State<MonthlyFilter> createState() => _MonthlyFilterState();
}

class _MonthlyFilterState extends State<MonthlyFilter> with ThemeContext {
  final DateTime dateNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: strings.previous,
          icon: const Icon(Icons.chevron_left_outlined),
          onPressed: () {
            widget.onChange(widget.startDate.subtractMonth(1));
            setState(() {});
          },
        ),
        const Spacing.x(4),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 70),
          child: Column(
            children: [
              Text(DateFormat('MMMM', strings.localeName).format(widget.startDate).toString()),
              if (widget.startDate.year != dateNow.year) Text(widget.startDate.year.toString(), style: textTheme.labelSmall),
            ],
          ),
        ),
        const Spacing.x(4),
        IconButton(
          tooltip: strings.next,
          icon: const Icon(Icons.chevron_right_outlined),
          onPressed: () {
            widget.onChange(widget.startDate.addMonth(1));
            setState(() {});
          },
        ),
      ],
    );
  }
}
