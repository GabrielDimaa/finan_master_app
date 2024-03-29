import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/i_input_validator.dart';

class InputGreaterThanValueValidator implements IInputValidator {
  final double value;

  InputGreaterThanValueValidator(this.value);

  @override
  String? validate(String? value) {
    final double? valueNum = double.tryParse(value?.replaceAll('.', '').replaceAll(',', '.') ?? '');

    if (valueNum == null) return R.strings.invalidValue;

    if (valueNum <= this.value) return '${R.strings.greaterThan} ${this.value.removeTrailingZeros()}.';

    return null;
  }
}