import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:flutter/foundation.dart';

class CategoriesNotifier extends ValueNotifier<CategoriesState> {
  final ICategoryFind _categoryFind;

  CategoriesNotifier({required ICategoryFind categoryFind})
      : _categoryFind = categoryFind,
        super(CategoriesState.start());

  Future<void> findAll() async {
    try {
      value = value.setLoading();

      final List<CategoryEntity> categories = await _categoryFind.findAll();
      value = value.setCategories(categories);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
