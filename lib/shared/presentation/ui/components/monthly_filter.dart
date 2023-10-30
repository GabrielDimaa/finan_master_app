import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyFilter extends StatefulWidget {
  final DateTime initialDate;
  final void Function(DateTime date) onChange;
  final bool enabled;

  const MonthlyFilter({Key? key, required this.initialDate, required this.onChange, this.enabled = true}) : super(key: key);

  @override
  State<MonthlyFilter> createState() => _MonthlyFilterState();
}

class _MonthlyFilterState extends State<MonthlyFilter> with ThemeContext {
  final DateTime dateNow = DateTime.now();

  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: strings.previous,
          icon: const Icon(Icons.chevron_left_outlined),
          onPressed: widget.enabled
              ? () {
                  dateTime = dateTime.subtractMonth(1);
                  widget.onChange(dateTime);
                  setState(() {});
                }
              : null,
        ),
        const Spacing.x(4),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 70),
          child: Column(
            children: [
              Text(DateFormat('MMMM', strings.localeName).format(dateTime).toString()),
              if (dateTime.year != dateNow.year) Text(dateTime.year.toString(), style: textTheme.labelSmall),
            ],
          ),
        ),
        const Spacing.x(4),
        IconButton(
          tooltip: strings.next,
          icon: const Icon(Icons.chevron_right_outlined),
          onPressed: widget.enabled
              ? () {
                  dateTime = dateTime.addMonth(1);
                  widget.onChange(dateTime);
                  setState(() {});
                }
              : null,
        ),
      ],
    );
  }
}
