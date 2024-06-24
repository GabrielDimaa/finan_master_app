extension StringExtension on String {
  int? toColor() => int.tryParse("0xFF$this");

  double moneyToDouble() => double.tryParse(replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;

  String capitalizeFirstLetter() {
    if (isEmpty) return this;

    return substring(0, 1).toUpperCase() + substring(1);
  }
}
