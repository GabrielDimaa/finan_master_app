import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';

class CategoryFind implements ICategoryFind {
  final ICategoryRepository _repository;

  CategoryFind({required ICategoryRepository repository}) : _repository = repository;

  @override
  Future<List<CategoryEntity>> findAll() => _repository.findAll();

  @override
  Future<CategoryEntity?> findById(String id) => _repository.findById(id);
}
