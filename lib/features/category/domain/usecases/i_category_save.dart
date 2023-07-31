import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/helpers/exceptions/category_exception.dart';
import 'package:finan_master_app/shared/classes/result.dart';

abstract interface class ICategorySave {
  Future<Result<CategoryEntity, CategoryException>> save(CategoryEntity entity);
}