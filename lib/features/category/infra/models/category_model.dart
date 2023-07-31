import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CategoryModel extends Model {
  String description;
  CategoryTypeEnum type;
  String color;
  int icon;

  CategoryModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.type,
    required this.color,
    required this.icon,
  });

  @override
  CategoryModel clone() {
    return CategoryModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      type: type,
      color: color,
      icon: icon,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'type': type.value,
      'color': color,
      'icon': icon,
    };
  }
}
