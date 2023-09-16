extension DateTimeExtension on DateTime {
  DateTime addMonth(int month) => copyWith(month: this.month + month);

  DateTime subtractMonth(int month) => copyWith(month: this.month - month);

  int getLastDayInMonth() => addMonth(1).subtract(const Duration(days: 1)).day;
}
