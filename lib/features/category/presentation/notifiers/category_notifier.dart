import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/states/category_state.dart';
import 'package:flutter/foundation.dart';

class CategoryNotifier extends ValueNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState.start());

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
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
