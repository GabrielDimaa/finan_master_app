import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/usecases/i_category_find.dart';
import 'package:finan_master_app/features/category/helpers/exceptions/category_exception.dart';
import 'package:finan_master_app/shared/classes/result.dart';

class CategoryFind implements ICategoryFind {
  final ICategoryRepository _repository;

  CategoryFind({required ICategoryRepository repository}) : _repository = repository;

  @override
  Future<Result<List<CategoryEntity>, CategoryException>> findAll() => _repository.findAll();

  @override
  Future<Result<CategoryEntity, CategoryException>> findById(String id) => _repository.findById(id);
}