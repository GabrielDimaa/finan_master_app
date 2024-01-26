import 'package:collection/collection.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';

class ReportCategoryEntity {
  final CategoryEntity category;

  final List<ITransactionEntity> transactions;

  double get amount => transactions.map((transaction) => transaction.amount).sum;

  ReportCategoryEntity({required this.category, required this.transactions});
}
