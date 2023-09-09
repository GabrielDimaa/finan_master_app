import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';

abstract interface class ICategoryFind {
  Future<List<CategoryEntity>> findAll({CategoryTypeEnum? type});

  Future<CategoryEntity?> findById(String id);
}
