import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

enum DatePeriodEnum {
  today,
  sevenDays,
  oneMonth,
  threeMonth,
  sixMonth,
  oneYear;

  ({DateTime dateTimeInitial, DateTime dateTimeFinal}) getDateTime() {
    final DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return switch (this) {
      DatePeriodEnum.today => (dateTimeInitial: now, dateTimeFinal: now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)),
      DatePeriodEnum.sevenDays => (dateTimeInitial: now.subtract(const Duration(days: 7)), dateTimeFinal: now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)),
      DatePeriodEnum.oneMonth => (dateTimeInitial: now.getInitialMonth(), dateTimeFinal: now.getFinalMonth()),
      DatePeriodEnum.threeMonth => (dateTimeInitial: now.getInitialMonth().subtractMonths(3), dateTimeFinal: now.getFinalMonth()),
      DatePeriodEnum.sixMonth => (dateTimeInitial: now.getInitialMonth().subtractMonths(6), dateTimeFinal: now.getFinalMonth()),
      DatePeriodEnum.oneYear => (dateTimeInitial: now.getInitialMonth().subtractMonths(12), dateTimeFinal: now.getFinalMonth()),
    };
  }

  static DatePeriodEnum? getByDateTime(DateTime dateTimeInitial, DateTime dateTimeFinal) {
    final DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (dateTimeInitial.compareTo(now) == 0 && dateTimeFinal.compareTo(now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)) == 0) return today;
    if (dateTimeInitial.compareTo(now.subtract(const Duration(days: 7))) == 0 && dateTimeFinal.compareTo(now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)) == 0) return sevenDays;

    if (dateTimeFinal.compareTo(now.getFinalMonth()) == 0) {
      if (dateTimeInitial.compareTo(now.getInitialMonth()) == 0) return oneMonth;
      if (dateTimeInitial.compareTo(now.getInitialMonth().subtractMonths(3)) == 0) return threeMonth;
      if (dateTimeInitial.compareTo(now.getInitialMonth().subtractMonths(6)) == 0) return sixMonth;
      if (dateTimeInitial.compareTo(now.getInitialMonth().subtractMonths(12)) == 0) return oneYear;
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
