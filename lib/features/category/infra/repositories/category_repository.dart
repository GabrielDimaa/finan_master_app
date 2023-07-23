import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/exception/category_exception.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_data_source.dart';
import 'package:finan_master_app/features/category/infra/mappers/category_mapper.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CategoryRepository implements ICategoryRepository {
  final ICategoryDataSource _dataSource;

  CategoryRepository({required ICategoryDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<Result<List<CategoryEntity>, CategoryException>> findAll() async {
    final List<CategoryModel> categories = await _dataSource.findAll();
    return Result.success(categories.map((c) => CategoryMapper().toEntity(c)).toList());
  }

  @override
  Future<Result<CategoryEntity, CategoryException>> findById(String id) async {
    final CategoryModel? category = await _dataSource.findById(id);

    if (category == null) return Result.failure(CategoryException(R.strings.categoryNotFound, null));

    return Result.success(CategoryMapper().toEntity(category));
  }
}
