import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({String? text}) {
    if (text != null) formatEditUpdate(const TextEditingValue(), TextEditingValue(text: text));
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;

    String newValueText = newValue.text.replaceAll('.', '').replaceAll(',', '');

    final double value = double.parse(newValueText);
    final formatter = NumberFormat('#,##0.00', R.locale.languageCode);
    final String newText = formatter.format(value / 100);

    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}
