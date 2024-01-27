import 'package:collection/collection.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/reports/domain/entities/report_category_entity.dart';
import 'package:finan_master_app/features/reports/domain/use_cases/i_report_categories_find.dart';
import 'package:finan_master_app/features/reports/presentation/states/report_categories_state.dart';
import 'package:flutter/foundation.dart';

class ReportCategoriesNotifier extends ValueNotifier<ReportCategoriesState> {
  final IReportCategoriesFind _reportCategoriesFind;

  ReportCategoriesNotifier(IReportCategoriesFind reportCategoriesFind)
      : _reportCategoriesFind = reportCategoriesFind,
        super(ReportCategoriesState.start());

  List<ReportCategoryEntity> reportCategoriesIncomes = [];
  List<ReportCategoryEntity> reportCategoriesExpenses = [];

  double get totalIncomes => reportCategoriesIncomes.map((e) => e.amount).sum;
  double get totalExpenses => reportCategoriesExpenses.map((e) => e.amount).sum;

  Future<void> findByPeriod(DateTime? startDate, DateTime? endDate) async {
    try {
      value = value.setLoading();

      await Future.wait([
        Future(() async => reportCategoriesIncomes = await _reportCategoriesFind.findByPeriod(startDate: startDate, endDate: endDate, type: CategoryTypeEnum.income)),
        Future(() async => reportCategoriesExpenses = await _reportCategoriesFind.findByPeriod(startDate: startDate, endDate: endDate, type: CategoryTypeEnum.expense)),
      ]);

      value = value.setLoaded();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
