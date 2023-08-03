import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

abstract interface class ICategorySave {
  Future<Result<CategoryEntity, BaseException>> save(CategoryEntity entity);
}
