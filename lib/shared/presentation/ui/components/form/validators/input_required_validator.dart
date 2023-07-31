import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_validator.dart';

class InputRequiredValidator implements IInputValidator {
  @override
  String get message => R.strings.requiredField;

  @override
  String? validate(String? value) {
    return value == null || value.isEmpty ? message : null;
  }
}
