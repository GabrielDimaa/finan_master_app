import 'dart:math';

import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:intl/intl.dart';

const _daysInMonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

extension DateTimeExtension on DateTime {
  DateTime getInitialMonth() => DateTime(year, month, 1);

  DateTime getFinalMonth() => DateTime(year, month, getLastDayInMonth(), 23, 59, 59, 999);

  int getLastDayInMonth() => copyWith(month: month + 1, day: 0).day;

  DateTime subtractMonths(int month) => addMonths(month * -1);

  DateTime addMonths(int value) {
    var r = value % 12;
    var q = (value - r) ~/ 12;
    var newYear = year + q;
    var newMonth = month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    var newDay = min(day, daysInMonth(newYear, newMonth));
    if (isUtc) {
      return DateTime.utc(newYear, newMonth, newDay, hour, minute, second, millisecond, microsecond);
    } else {
      return DateTime(newYear, newMonth, newDay, hour, minute, second, millisecond, microsecond);
    }
  }

  bool isLeapYear(int value) => value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);

  int daysInMonth(int year, int month) {
    var result = _daysInMonth[month];
    if (month == 2 && isLeapYear(year)) result++;
    return result;
  }

  String format() => DateFormat.yMd(AppLocale().locale.languageCode).format(this);

  String formatDateToRelative() {
    final DateTime now = DateTime.now();

    if (isSameDay(now, this)) return R.strings.today;

    if (isSameDay(now.subtract(const Duration(days: 1)), this)) return R.strings.yesterday;

    return DateFormat('d MMM', AppLocale().locale.languageCode).format(this).replaceAll(".", "").toUpperCase();
  }

  bool isSameDay(DateTime date1, DateTime date2) => date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}
