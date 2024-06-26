import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => message;
}

class OperationCanceledException implements Exception {
  final String message;

  OperationCanceledException({String? message}) : message = message ?? R.strings.operationCanceled;

  @override
  String toString() => message;
}
