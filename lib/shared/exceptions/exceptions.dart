class BaseException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const BaseException(this.message, this.stackTrace);

  @override
  String toString() => message;
}

class NotFoundException extends BaseException {
  NotFoundException(super.message, super.stackTrace);
}

class ValidationException extends BaseException {
  ValidationException(super.message, super.stackTrace);
}
