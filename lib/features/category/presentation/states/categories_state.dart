import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/exception/category_exception.dart';

sealed class CategoriesState {
  final List<CategoryEntity> categories;
  final bool loading;
  final CategoryException? exception;

  const CategoriesState({
    required this.categories,
    this.loading = false,
    this.exception,
  });

  factory CategoriesState.start() => const StartCategoriesState();

  CategoriesState setCategories(List<CategoryEntity> categories) => categories.isEmpty ? EmptyCategoriesState() : GettedCategoriesState(categories: categories);

  CategoriesState setLoading([bool loading = true]) => LoadingCategoriesState(categories: categories, loading: loading);

  CategoriesState setError(CategoryException exception) => ErrorCategoriesState(exception: exception, categories: categories);
}

class StartCategoriesState extends CategoriesState {
  const StartCategoriesState() : super(categories: const []);
}

class GettedCategoriesState extends CategoriesState {
  const GettedCategoriesState({required super.categories}) : super(loading: false);
}

class EmptyCategoriesState extends CategoriesState {
  EmptyCategoriesState() : super(categories: [], loading: false);
}

class LoadingCategoriesState extends CategoriesState {
  const LoadingCategoriesState({required super.categories, bool loading = true}) : super(loading: loading);
}

class ErrorCategoriesState extends CategoriesState {
  const ErrorCategoriesState({required super.exception, required super.categories}) : super(loading: false);
}
