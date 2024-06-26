import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/i_input_validator.dart';

class InputRequiredValidator implements IInputValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return R.strings.requiredField;

    return null;
  }
}
