import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/shared/infra/mappers/mapper.dart';

class CategoryMapper implements Mapper<CategoryEntity, CategoryModel> {
  @override
  CategoryModel fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      type: entity.type,
      color: entity.color,
      icon: entity.icon,
    );
  }

  @override
  CategoryEntity toEntity(CategoryModel model) {
    return CategoryEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      type: model.type,
      color: model.color,
      icon: model.icon,
    );
  }
}
