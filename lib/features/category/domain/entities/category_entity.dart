import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CategoryEntity extends Entity {
  String description;
  CategoryTypeEnum? type;
  String color;
  int icon;

  CategoryEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.type,
    required this.color,
    required this.icon,
  });
}
