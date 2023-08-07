import 'package:finan_master_app/shared/presentation/ui/components/form/mask/currency_input_formatter.dart';
import 'package:flutter/services.dart';

abstract class MaskInputFormatter {
  static TextInputFormatter currency({String? value}) => CurrencyInputFormatter(text: value);
}
