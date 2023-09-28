import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';

abstract interface class ICategoryRepository {
  Future<List<CategoryEntity>> findAll({CategoryTypeEnum? type, bool deleted = false});

  Future<CategoryEntity?> findById(String id);

  Future<CategoryEntity> save(CategoryEntity entity);

  Future<void> delete(CategoryEntity entity);
}
