import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/reports/domain/entities/report_category_entity.dart';
import 'package:finan_master_app/features/reports/domain/repositories/i_report_categories_repository.dart';
import 'package:finan_master_app/features/reports/domain/use_cases/i_report_categories_find.dart';

class ReportCategoriesFind implements IReportCategoriesFind {
  final IReportCategoriesRepository _repository;

  ReportCategoriesFind({required IReportCategoriesRepository repository}) : _repository = repository;

  @override
  Future<List<ReportCategoryEntity>> findByPeriod({required DateTime startDate, required DateTime endDate, required CategoryTypeEnum type}) => _repository.findByPeriod(startDate: startDate, endDate: endDate, type: type);
}
