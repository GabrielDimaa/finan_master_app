import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CategorySave implements ICategorySave {
  final ICategoryRepository _repository;

  CategorySave({required ICategoryRepository repository}) : _repository = repository;

  @override
  Future<CategoryEntity> save(CategoryEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.type == null) throw ValidationException(R.strings.uninformedTypeCategory);
    if (entity.icon == 0) throw ValidationException(R.strings.uninformedIcon);
    if (entity.color.isEmpty) throw ValidationException(R.strings.uninformedColor);

    return await _repository.save(entity);
  }
}
