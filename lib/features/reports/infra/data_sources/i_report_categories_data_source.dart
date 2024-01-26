import 'package:finan_master_app/features/reports/infra/models/report_category_model.dart';

abstract interface class IReportCategoriesDataSource {
  Future<List<ReportCategoryModel>> findIncomesByPeriod(DateTime startDate, DateTime endDate);

  Future<List<ReportCategoryModel>> findExpensesByPeriod(DateTime startDate, DateTime endDate);
}
