import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';

sealed class CategoryState {
  final CategoryEntity category;

  const CategoryState({required this.category});

  factory CategoryState.start() => StartCategoryState();

  CategoryState changedCategory() => ChangedCategoryState(category: category);

  CategoryState setSaving() => SavingCategoryState(category: category);

  CategoryState setError(String message) => ErrorCategoryState(category: category, message: message);
}

class StartCategoryState extends CategoryState {
  StartCategoryState()
      : super(
          category: CategoryEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: '',
            type: null,
            color: '',
            icon: 0,
          ),
        );
}

class ChangedCategoryState extends CategoryState {
  const ChangedCategoryState({required super.category});
}

class SavingCategoryState extends CategoryState {
  const SavingCategoryState({required super.category});
}

class ErrorCategoryState extends CategoryState {
  final String message;

  const ErrorCategoryState({required super.category, required this.message});
}
