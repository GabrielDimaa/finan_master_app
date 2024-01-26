sealed class ReportCategoriesState {
  const ReportCategoriesState();

  factory ReportCategoriesState.start() => StartReportCategoriesState();

  ReportCategoriesState setLoading() => LoadingReportCategoriesState();

  ReportCategoriesState setLoaded() => LoadedReportCategoriesState();

  ReportCategoriesState setError(String message) => ErrorReportCategoriesState(message: message);
}

class StartReportCategoriesState extends ReportCategoriesState {}

class LoadingReportCategoriesState extends ReportCategoriesState {}

class LoadedReportCategoriesState extends ReportCategoriesState {}

class ErrorReportCategoriesState extends ReportCategoriesState {
  final String message;

  const ErrorReportCategoriesState({required this.message});
}
