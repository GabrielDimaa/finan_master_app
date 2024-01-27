import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/reports/domain/entities/report_category_entity.dart';
import 'package:finan_master_app/features/reports/domain/repositories/i_report_categories_repository.dart';
import 'package:finan_master_app/features/reports/helpers/report_category_factory.dart';
import 'package:finan_master_app/features/reports/infra/data_sources/i_report_categories_data_source.dart';
import 'package:finan_master_app/features/reports/infra/models/report_category_model.dart';

class ReportCategoriesRepository implements IReportCategoriesRepository {
  final IReportCategoriesDataSource _dataSource;

  ReportCategoriesRepository({required IReportCategoriesDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<List<ReportCategoryEntity>> findByPeriod({required DateTime? startDate, required DateTime? endDate, required CategoryTypeEnum type}) async {
    late final List<ReportCategoryModel> result;

    if (type == CategoryTypeEnum.income) {
      result = await _dataSource.findIncomesByPeriod(startDate, endDate);
    } else {
      result = await _dataSource.findExpensesByPeriod(startDate, endDate);
    }

    return result.map((e) => ReportCategoryFactory.toEntity(e)).toList();
  }
}
