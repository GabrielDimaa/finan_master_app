import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class InputRequiredValidator {
  String? validate(String? value) {
    return value == null || value.isEmpty ? R.strings.requiredField : null;
  }
}
