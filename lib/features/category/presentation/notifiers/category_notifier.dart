import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_delete.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_save.dart';
import 'package:finan_master_app/features/category/presentation/states/category_state.dart';
import 'package:flutter/foundation.dart';

class CategoryNotifier extends ValueNotifier<CategoryState> {
  final ICategorySave _categorySave;
  final ICategoryDelete _categoryDelete;

  CategoryNotifier({required ICategorySave categorySave, required ICategoryDelete categoryDelete})
      : _categoryDelete = categoryDelete,
        _categorySave = categorySave,
        super(CategoryState.start());

  CategoryEntity get category => value.category;

  void updateCategory(CategoryEntity category) => value = value.updateCategory(category);

  void setType(CategoryTypeEnum? type) {
    value.category.type = type;
    value = value.changedCategory();
  }

  void setColorIcon({required String color, required int icon}) async {
    value.category.color = color;
    value.category.icon = icon;
    value = value.changedCategory();
  }

  Future<void> save() async {
    try {
      value = value.setSaving();
      await _categorySave.save(value.category);
      value = value.changedCategory();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      value = value.setDeleting();
      await _categoryDelete.delete(value.category);
      value = value.changedCategory();
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
