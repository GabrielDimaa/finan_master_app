import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:flutter/material.dart';

class TabBarViewCategories extends StatelessWidget {
  final GettedCategoriesState state;

  const TabBarViewCategories({Key? key, required this.state}) : super(key: key);

  List<CategoryEntity> get expenses => state.categories.where((category) => category.type == CategoryTypeEnum.expense).toList();

  List<CategoryEntity> get incomes => state.categories.where((category) => category.type == CategoryTypeEnum.income).toList();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        ListView.separated(
          itemCount: expenses.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => _categoryTile(expenses[index]),
        ),
        ListView.separated(
          itemCount: incomes.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => _categoryTile(incomes[index]),
        ),
      ],
    );
  }

  Widget _categoryTile(CategoryEntity category) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(int.parse("0x${category.color}")),
        child: Icon(IconData(category.icon, fontFamily: 'MaterialIcons')),
      ),
      title: Text(category.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}