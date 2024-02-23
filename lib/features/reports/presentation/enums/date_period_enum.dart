import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/material.dart';

enum DatePeriodEnum {
  today,
  sevenDays,
  oneMonth,
  threeMonth,
  sixMonth,
  oneYear;

  DateTimeRange getDateTime() {
    final DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return switch (this) {
      DatePeriodEnum.today => DateTimeRange(start: now, end: now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)),
      DatePeriodEnum.sevenDays => DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)),
      DatePeriodEnum.oneMonth => DateTimeRange(start: now.getInitialMonth(), end: now.getFinalMonth()),
      DatePeriodEnum.threeMonth => DateTimeRange(start: now.getInitialMonth().subtractMonths(3), end: now.getFinalMonth()),
      DatePeriodEnum.sixMonth => DateTimeRange(start: now.getInitialMonth().subtractMonths(6), end: now.getFinalMonth()),
      DatePeriodEnum.oneYear => DateTimeRange(start: now.getInitialMonth().subtractMonths(12), end: now.getFinalMonth()),
    };
  }

  static DatePeriodEnum? getByDateRange(DateTimeRange dateRange) {
    final DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (dateRange.start.compareTo(now) == 0 && dateRange.end.compareTo(now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)) == 0) return today;
    if (dateRange.start.compareTo(now.subtract(const Duration(days: 7))) == 0 && dateRange.end.compareTo(now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)) == 0) return sevenDays;

    if (dateRange.end.compareTo(now.getFinalMonth()) == 0) {
      if (dateRange.start.compareTo(now.getInitialMonth()) == 0) return oneMonth;
      if (dateRange.start.compareTo(now.getInitialMonth().subtractMonths(3)) == 0) return threeMonth;
      if (dateRange.start.compareTo(now.getInitialMonth().subtractMonths(6)) == 0) return sixMonth;
      if (dateRange.start.compareTo(now.getInitialMonth().subtractMonths(12)) == 0) return oneYear;
    }

    return null;
  }
}

extension DatePeriodEnumExtension on DatePeriodEnum {
  String get description => switch (this) {
        DatePeriodEnum.today => R.strings.today,
        DatePeriodEnum.sevenDays => R.strings.sevenDays,
        DatePeriodEnum.oneMonth => R.strings.oneMonth,
        DatePeriodEnum.threeMonth => R.strings.threeMonth,
        DatePeriodEnum.sixMonth => R.strings.sixMonth,
        DatePeriodEnum.oneYear => R.strings.oneYear,
      };
}
