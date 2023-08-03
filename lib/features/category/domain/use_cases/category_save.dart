import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_save.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CategorySave implements ICategorySave {
  final ICategoryRepository _repository;

  CategorySave({required ICategoryRepository repository}) : _repository = repository;

  @override
  Future<Result<CategoryEntity, BaseException>> save(CategoryEntity entity) async {
    if (entity.description.isEmpty) return Result.failure(ValidationException(R.strings.uninformedDescription, null));
    if (entity.type == null) return Result.failure(ValidationException(R.strings.uninformedTypeCategory, null));
    if (entity.icon == 0) return Result.failure(ValidationException(R.strings.uninformedIcon, null));
    if (entity.color.isEmpty) return Result.failure(ValidationException(R.strings.uninformedColor, null));

    return await _repository.save(entity);
  }
}
