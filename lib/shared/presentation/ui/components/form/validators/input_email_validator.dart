import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/i_input_validator.dart';

class InputEmailValidator implements IInputValidator {
  @override
  String? validate(String? value) {
    final bool valid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value ?? '');
    if (!valid) return R.strings.emailInvalid;

    return null;
  }
}
