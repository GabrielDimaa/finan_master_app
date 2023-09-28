import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/helpers/factories/category_factory.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';

class CategoryRepository implements ICategoryRepository {
  final ICategoryLocalDataSource _dataSource;

  CategoryRepository({required ICategoryLocalDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<List<CategoryEntity>> findAll({CategoryTypeEnum? type, bool deleted = false}) async {
    List<CategoryModel> categories = [];

    if (type == null) {
      categories = await _dataSource.findAll(deleted: deleted);
    } else {
      categories = await _dataSource.findAll(where: 'type = ?', whereArgs: [type.value], deleted: deleted);
    }

    return categories.map((c) => CategoryFactory.toEntity(c)).toList();
  }

  @override
  Future<CategoryEntity?> findById(String id) async {
    final CategoryModel? category = await _dataSource.findById(id);
    if (category == null) return null;

    return CategoryFactory.toEntity(category);
  }

  @override
  Future<CategoryEntity> save(CategoryEntity entity) async {
    final CategoryModel category = await _dataSource.upsert(CategoryFactory.fromEntity(entity));
    return CategoryFactory.toEntity(category);
  }

  @override
  Future<void> delete(CategoryEntity entity) => _dataSource.delete(CategoryFactory.fromEntity(entity));
}
