extension StringExtension on String {
  int? toColor() => int.tryParse("0xFF$this");

  double moneyToDouble() => double.tryParse(replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;
}
