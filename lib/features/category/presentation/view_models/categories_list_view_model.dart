import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/cupertino.dart';

class CategoriesViewModel extends ChangeNotifier {
  late final Command0<List<CategoryEntity>> findAll;

  CategoriesViewModel({required ICategoryFind categoryFind}) {
    findAll = Command0(categoryFind.findAll);
  }
}
