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

      final result = await _categoryFind.findAll();

      result.fold(
        (success) => value = value.setCategories(success),
        (failure) => value = value.setError(failure.message),
      );
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
