import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';

sealed class CategoriesState {
  const CategoriesState();

  factory CategoriesState.start() => const StartCategoriesState();

  CategoriesState setCategories(List<CategoryEntity> categories) => categories.isEmpty ? const EmptyCategoriesState() : ListCategoriesState(categories);

  CategoriesState setLoading() => const LoadingCategoriesState();

  CategoriesState setError(String message) => ErrorCategoriesState(message);
}

class StartCategoriesState extends CategoriesState {
  const StartCategoriesState();
}

class ListCategoriesState extends CategoriesState {
  final List<CategoryEntity> categories;

  ListCategoriesState(this.categories);
}

class EmptyCategoriesState extends CategoriesState {
  const EmptyCategoriesState();
}

class LoadingCategoriesState extends CategoriesState {
  const LoadingCategoriesState();
}

class ErrorCategoriesState extends CategoriesState {
  final String message;

  const ErrorCategoriesState(this.message);
}
