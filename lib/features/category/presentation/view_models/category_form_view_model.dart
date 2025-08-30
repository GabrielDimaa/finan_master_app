import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_delete.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_save.dart';
import 'package:finan_master_app/features/category/helpers/factories/category_factory.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/cupertino.dart';

class CategoryFormViewModel extends ChangeNotifier {
  late final Command1<CategoryEntity, CategoryEntity> save;
  late final Command1<void, CategoryEntity> delete;

  CategoryFormViewModel({required ICategorySave categorySave, required ICategoryDelete categoryDelete}) {
    save = Command1(categorySave.save);
    delete = Command1(categoryDelete.delete);
  }

  bool get isLoading => save.running || delete.running;

  CategoryEntity _category = CategoryFactory.newEntity();

  CategoryEntity get category => _category;

  void load(CategoryEntity value) {
    _category = value;
    notifyListeners();
  }

  void setType(CategoryTypeEnum? value) {
    _category.type = value;
    notifyListeners();
  }

  void setColorIcon({required String color, required int icon}) async {
    _category.color = color;
    _category.icon = icon;
    notifyListeners();
  }
}