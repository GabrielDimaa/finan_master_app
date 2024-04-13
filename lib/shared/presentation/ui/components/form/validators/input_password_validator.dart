import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/i_input_validator.dart';

class InputPasswordValidator implements IInputValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.trim().length < kMinPasswordLength) return R.strings.shortPassword;

    return null;
  }
}
