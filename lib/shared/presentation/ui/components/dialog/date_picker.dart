import 'package:flutter/material.dart';

final DateTime _firstDate = DateTime(2000, 1, 1);
final DateTime _lastDate = DateTime(2100, 12, 31);

Future<DateTime?> showDatePickerDefault({required BuildContext context, DateTime? initialDate}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: _firstDate,
    lastDate: _lastDate,
  );
}

Future<DateTimeRange?> showDateRangePickerDefault({required BuildContext context, DateTimeRange? initialDateRange}) {
  return showDateRangePicker(
    context: context,
    firstDate: _firstDate,
    lastDate: _lastDate,
    initialDateRange: initialDateRange ?? DateTimeRange(start: DateTime.now(), end: DateTime.now()),
  );
}