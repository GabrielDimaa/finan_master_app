import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:flutter/foundation.dart';

class CategoriesNotifier extends ValueNotifier<CategoriesState> {
  final ICategoryFind _categoryFind;

  CategoriesNotifier({required ICategoryFind categoryFind})
      : _categoryFind = categoryFind,
        super(CategoriesState.start());

  Future<void> findAll({CategoryTypeEnum? type, bool deleted = false}) async {
    try {
      value = value.setLoading();

      final List<CategoryEntity> categories = await _categoryFind.findAll(type: type, deleted: deleted);
      value = value.setCategories(categories);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> onRefresh({bool deleted = false}) async {
    final List<CategoryEntity> categories = await _categoryFind.findAll(deleted: deleted);
    value = value.setCategories(categories);
  }
}
