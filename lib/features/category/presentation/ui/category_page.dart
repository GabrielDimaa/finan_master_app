import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  static const route = 'category';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with ThemeContext {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBarMedium(
        title: Text(strings.category),
        actions: [
          FilledButton(
            onPressed: () {},
            child: Text(strings.save),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacing.y(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                decoration: InputDecoration(label: Text(strings.description)),
                textCapitalization: TextCapitalization.sentences,
                validator: null,
                onSaved: (String? value) => null,
              ),
            ),
            const Spacing.y(),
            const Divider(),
            const Spacing.y(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(strings.typeCategory, style: textTheme.bodySmall),
            ),
            RadioListTile<CategoryTypeEnum>(
              title: Text(CategoryTypeEnum.expense.description),
              value: CategoryTypeEnum.expense,
              groupValue: null,
              onChanged: (CategoryTypeEnum? type) {},
            ),
            RadioListTile<CategoryTypeEnum>(
              title: Text(CategoryTypeEnum.income.description),
              value: CategoryTypeEnum.income,
              groupValue: null,
              onChanged: (CategoryTypeEnum? type) {},
            ),
            const Divider(),
            const Spacing.y(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(strings.typeCategory, style: textTheme.bodySmall),
            ),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(strings.icon),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> save() async {
    try {
      //save
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();
      }
    } catch (e) {
      //catch
    }
  }
}
