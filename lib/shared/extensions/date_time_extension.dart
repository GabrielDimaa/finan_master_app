extension DateTimeExtension on DateTime {
  DateTime addMonth(int month) => copyWith(month: this.month + month);

  DateTime substractMonth(int month) => copyWith(month: this.month - month);
}
