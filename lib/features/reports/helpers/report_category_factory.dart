import 'package:finan_master_app/features/category/helpers/factories/category_factory.dart';
import 'package:finan_master_app/features/reports/domain/entities/report_category_entity.dart';
import 'package:finan_master_app/features/reports/infra/models/report_category_model.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/financial_operation.dart';

abstract class ReportCategoryFactory {
  static ReportCategoryEntity toEntity(ReportCategoryModel model) {
    return ReportCategoryEntity(
      category: CategoryFactory.toEntity(model.category),
      transactions: model.transactions.map((e) => FinancialOperationFactory.toEntity(e)).toList(),
    );
  }
}
