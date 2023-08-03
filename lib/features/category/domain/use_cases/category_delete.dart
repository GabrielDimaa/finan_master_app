import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_delete.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

class CategoryDelete implements ICategoryDelete {
  final ICategoryRepository _repository;

  CategoryDelete({required ICategoryRepository repository}) : _repository = repository;

  @override
  Future<Result<dynamic, BaseException>> delete(CategoryEntity entity) => _repository.delete(entity);
}
