import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';

abstract interface class ICategoryFind {
  Future<List<CategoryEntity>> findAll();

  Future<CategoryEntity?> findById(String id);
}
