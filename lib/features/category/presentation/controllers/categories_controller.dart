import 'package:finan_master_app/features/category/domain/usecases/i_category_finds.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/shared/presentation/ui/components/error_dialog.dart';
import 'package:flutter/widgets.dart';

class CategoriesController {
  final ICategoryFinds _categoryFinds;

  CategoriesController({required ICategoryFinds categoryFinds}) : _categoryFinds = categoryFinds;

  final ValueNotifier<CategoriesState> stateNotifier = ValueNotifier(CategoriesState.start());

  CategoriesState get state => stateNotifier.value;

  set state(CategoriesState value) => stateNotifier.value = value;

  Future<void> init(BuildContext context) async {
    try {
      state = state.setLoading();

      final result = await _categoryFinds.findAll();

      result.fold(
        (success) => state = state.setCategories(success),
        (failure) => state = state.setError(failure),
      );
    } catch (e) {
      state = state.setLoading(false);
      await ErrorDialog.show(context, e.toString());
    }
  }
}
