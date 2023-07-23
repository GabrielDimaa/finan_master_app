class LocalDataSourceException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  final int? code;

  const LocalDataSourceException(this.message, this.code, this.stackTrace);

  @override
  String toString() => message;
}
