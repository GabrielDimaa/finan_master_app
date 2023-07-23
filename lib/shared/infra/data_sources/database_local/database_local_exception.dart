class DatabaseLocalException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  final int? code;

  const DatabaseLocalException(this.message, this.code, this.stackTrace);

  @override
  String toString() => message;
}
