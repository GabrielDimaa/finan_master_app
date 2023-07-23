class BaseException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const BaseException(this.message, this.stackTrace);

  @override
  String toString() => message;
}
