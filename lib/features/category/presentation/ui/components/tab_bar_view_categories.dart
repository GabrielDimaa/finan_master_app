import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/ui/category_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabBarViewCategories extends StatelessWidget {
  final CategoriesNotifier notifier;

  const TabBarViewCategories({Key? key, required this.notifier}) : super(key: key);

  List<CategoryEntity> get expenses => notifier.value.categories.where((category) => category.type == CategoryTypeEnum.expense).toList();

  List<CategoryEntity> get incomes => notifier.value.categories.where((category) => category.type == CategoryTypeEnum.income).toList();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        ListView.separated(
          itemCount: expenses.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => Column(
            children: [
              _categoryTile(context: context, category: expenses[index]),
              if (index == expenses.length - 1) const SizedBox(height: 50),
            ],
          ),
        ),
        ListView.separated(
          itemCount: incomes.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => Column(
            children: [
              _categoryTile(context: context, category: incomes[index]),
              if (index == incomes.length - 1) const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryTile({required BuildContext context, required CategoryEntity category}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(category.color.toColor()!),
        child: Icon(category.icon.parseIconData(), color: Colors.white),
      ),
      title: Text(category.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final FormResultNavigation<CategoryEntity>? result = await context.pushNamed(CategoryFormPage.route, extra: category);
        if (result == null) return;

        notifier.findAll();
      },
    );
  }
}
