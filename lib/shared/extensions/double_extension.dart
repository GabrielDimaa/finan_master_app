import 'dart:math';

import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:intl/intl.dart';

extension DoubleExtension on double {
  NumberFormat get _numberFormat => NumberFormat.simpleCurrency(locale: R.locale.toString());

  String get money => NumberFormat.currency(symbol: _numberFormat.currencySymbol, locale: _numberFormat.locale, decimalDigits: _numberFormat.decimalDigits).format(this).trim();

  String get moneyWithoutSymbol => NumberFormat.currency(name: '', locale: _numberFormat.locale, decimalDigits: _numberFormat.decimalDigits).format(this).trim();

  String get formatted => NumberFormat.decimalPattern(R.locale.toString()).format(this);

  double toRound(num fractionDigits) {
    final double mod = double.tryParse(pow(10.0, fractionDigits).toString()) ?? (throw Exception('Não foi possível efetuar a conversão.'));

    return ((this * mod).round().toDouble() / mod);
  }

  String removeTrailingZeros() {
    String formattedNumber = toString();

    if (formattedNumber.contains('.')) {
      formattedNumber = formattedNumber.replaceAll(RegExp(r'0*$'), '');
      formattedNumber = formattedNumber.replaceAll(RegExp(r'\.$'), '');
    }

    return formattedNumber;
  }

  double truncateFractionalDigits(int fractionalDigits) => (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
}
