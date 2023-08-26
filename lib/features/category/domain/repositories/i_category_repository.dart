import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';

abstract interface class ICategoryRepository {
  Future<List<CategoryEntity>> findAll();

  Future<CategoryEntity?> findById(String id);

  Future<CategoryEntity> save(CategoryEntity entity);

  Future<void> delete(CategoryEntity entity);
}
