abstract interface class IInputValidator {
  String get message;

  String? validate(String? value);
}