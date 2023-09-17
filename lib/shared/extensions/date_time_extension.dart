import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime addMonth(int month) => copyWith(month: this.month + month);

  DateTime subtractMonth(int month) => copyWith(month: this.month - month);

  int getLastDayInMonth() => addMonth(1).copyWith(day: 1).subtract(const Duration(days: 1)).day;

  String format() => DateFormat.yMd(AppLocale().locale.languageCode).format(this);

  String formatDateToRelative() {
    final DateTime now = DateTime.now();

    if (isSameDay(now, this)) return R.strings.today;

    if (isSameDay(now.subtract(const Duration(days: 1)), this)) return R.strings.yesterday;

    return DateFormat.MMMd(AppLocale().locale.languageCode).format(this);
  }

  bool isSameDay(DateTime date1, DateTime date2) => date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}
