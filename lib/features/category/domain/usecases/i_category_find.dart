import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

abstract interface class ICategoryFind {
  Future<Result<List<CategoryEntity>, BaseException>> findAll();

  Future<Result<CategoryEntity, BaseException>> findById(String id);
}
