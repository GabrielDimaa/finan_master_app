import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/usecases/i_category_finds.dart';
import 'package:finan_master_app/features/category/exception/category_exception.dart';
import 'package:finan_master_app/shared/classes/result.dart';

class CategoryFinds implements ICategoryFinds {
  final ICategoryRepository _repository;

  CategoryFinds({required ICategoryRepository repository}) : _repository = repository;

  @override
  Future<Result<List<CategoryEntity>, CategoryException>> findAll() => _repository.findAll();

  @override
  Future<Result<CategoryEntity, CategoryException>> findById(String id) => _repository.findById(id);
}
