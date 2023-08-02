import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';

sealed class CategoriesState {
  final List<CategoryEntity> categories;

  const CategoriesState(this.categories);

  factory CategoriesState.start() => const StartCategoriesState([]);

  CategoriesState setCategories(List<CategoryEntity> categories) => categories.isEmpty ? const EmptyCategoriesState([]) : ListCategoriesState(categories);

  CategoriesState setLoading() => const LoadingCategoriesState([]);

  CategoriesState setError(String message) => ErrorCategoriesState(message);
}

class StartCategoriesState extends CategoriesState {
  const StartCategoriesState(super.categories);
}

class ListCategoriesState extends CategoriesState {
  ListCategoriesState(super.categories);
}

class EmptyCategoriesState extends CategoriesState {
  const EmptyCategoriesState(super.categories);
}

class LoadingCategoriesState extends CategoriesState {
  const LoadingCategoriesState(super.categories);
}

class ErrorCategoriesState extends CategoriesState {
  final String message;

  const ErrorCategoriesState(this.message) : super(const []);
}
