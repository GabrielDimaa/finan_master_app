import 'package:finan_master_app/shared/presentation/ui/components/form/validators/i_input_validator.dart';

class InputValidators implements IInputValidator {
  final List<IInputValidator> _validators;

  InputValidators(this._validators);

  @override
  String? validate(String? text) {
    for (final validator in _validators) {
      final String? message = validator.validate(text);
      if (message?.isNotEmpty == true) return message;
    }

    return null;
  }
}
