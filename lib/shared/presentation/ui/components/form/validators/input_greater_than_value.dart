import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class InputGreaterThanValueValidator {
  final double value;

  InputGreaterThanValueValidator([this.value = 0]);

  String? validate(String? value) {
    if (value == null || value.isEmpty) return R.strings.requiredField;

    final double? valueNum = double.tryParse(value.replaceAll(".", "").replaceAll(",", "."));

    if (valueNum == null) return R.strings.invalidValue;

    if (valueNum <= this.value) return '${R.strings.greaterThan} ${this.value.removeTrailingZeros()}.';

    return null;
  }
}