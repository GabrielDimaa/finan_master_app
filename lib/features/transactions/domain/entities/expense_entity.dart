import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class ExpenseEntity extends Entity {
  String description;
  double value;
  DateTime date;
  String? obs;

  CategoryEntity? category;
  AccountEntity? account;

  ExpenseEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.value,
    required this.date,
    required this.obs,
    required this.category,
    required this.account,
  });
}
