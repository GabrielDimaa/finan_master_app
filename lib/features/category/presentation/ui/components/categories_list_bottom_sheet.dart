import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/presentation/ui/category_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesListBottomSheet extends StatefulWidget {
  final CategoryEntity? categorySelected;
  final List<CategoryEntity> categories;
  final void Function(CategoryEntity)? onCategoryCreated;

  const CategoriesListBottomSheet({Key? key, required this.categorySelected, required this.categories, this.onCategoryCreated}) : super(key: key);

  static Future<CategoryEntity?> show({
    required BuildContext context,
    required CategoryEntity? categorySelected,
    required List<CategoryEntity> categories,
    void Function(CategoryEntity)? onCategoryCreated,
  }) async {
    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => CategoriesListBottomSheet(categorySelected: categorySelected, categories: categories, onCategoryCreated: onCategoryCreated),
    );
  }

  @override
  State<CategoriesListBottomSheet> createState() => _CategoriesListBottomSheetState();
}

class _CategoriesListBottomSheetState extends State<CategoriesListBottomSheet> with ThemeContext {
  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      builder: (scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(strings.categories, style: textTheme.titleMedium),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Visibility(
                  visible: widget.categories.isNotEmpty,
                  replacement: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.manage_search_outlined, size: 36),
                      const Spacing.y(),
                      Text(strings.noCategoryRegistered),
                    ],
                  ),
                  child: RadioGroup<CategoryEntity>(
                    groupValue: widget.categorySelected,
                    onChanged: (value) => context.pop(value),
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: widget.categories.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, index) {
                        final CategoryEntity category = widget.categories[index];
                        return RadioListTile<CategoryEntity>(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(category.color.toColor()!),
                                child: Icon(category.icon.parseIconData(), color: Colors.white),
                              ),
                              const Spacing.x(),
                              Expanded(child: Text(category.description)),
                            ],
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          toggleable: true,
                          value: category,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.add_outlined),
                  label: Text(strings.newCategory),
                  onPressed: goCategory,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> goCategory() async {
    final FormResultNavigation<CategoryEntity>? result = await context.pushNamedWithAd(CategoryFormPage.route);

    if (result?.isSave == true && result?.value != null && widget.categories.any((category) => category.type == result?.value?.type)) {
      widget.categories.add(result!.value!);
      widget.onCategoryCreated?.call(result.value!);
    }
  }
}
