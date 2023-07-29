extension StringExtension on String {
  int? toColor() => int.tryParse("0xFF$this");
}
