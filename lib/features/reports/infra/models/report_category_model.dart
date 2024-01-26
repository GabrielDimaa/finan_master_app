import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/i_transaction_model.dart';

class ReportCategoryModel {
  final CategoryModel category;

  final List<ITransactionModel> transactions;

  ReportCategoryModel({required this.category, required this.transactions});
}
