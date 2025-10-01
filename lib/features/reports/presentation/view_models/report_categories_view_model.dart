import 'package:collection/collection.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/reports/domain/entities/report_category_entity.dart';
import 'package:finan_master_app/features/reports/domain/use_cases/i_report_categories_find.dart';
import 'package:finan_master_app/features/reports/presentation/enums/date_period_enum.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

typedef FindByPeriodParams = ({DateTime? startDate, DateTime? endDate});

class ReportCategoriesViewModel extends ChangeNotifier {
  final IReportCategoriesFind _reportCategoriesFind;

  late final Command1<void, FindByPeriodParams> findByPeriod;

  ReportCategoriesViewModel({required IReportCategoriesFind reportCategoriesFind}) : _reportCategoriesFind = reportCategoriesFind {
    findByPeriod = Command1(_findByPeriod);
  }

  List<ReportCategoryEntity> _reportCategoriesIncomes = [];
  List<ReportCategoryEntity> _reportCategoriesExpenses = [];

  List<ReportCategoryEntity> get reportCategoriesIncomes => _reportCategoriesIncomes;

  List<ReportCategoryEntity> get reportCategoriesExpenses => _reportCategoriesExpenses;

  double get totalIncomes => reportCategoriesIncomes.map((e) => e.amount).sum;

  double get totalExpenses => reportCategoriesExpenses.map((e) => e.amount).sum;

  Future<void> _findByPeriod(FindByPeriodParams params) async {
    await Future.wait([
      Future(() async => _reportCategoriesIncomes = await _reportCategoriesFind.findByPeriod(startDate: params.startDate, endDate: params.endDate, type: CategoryTypeEnum.income)),
      Future(() async => _reportCategoriesExpenses = await _reportCategoriesFind.findByPeriod(startDate: params.startDate, endDate: params.endDate, type: CategoryTypeEnum.expense)),
    ]);
  }
}
