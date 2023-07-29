import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/category_notifier.dart';
import 'package:finan_master_app/features/category/presentation/ui/components/color_and_icon_category.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/group_tile.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoryPage extends StatefulWidget {
  static const route = 'category';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with ThemeContext {
  final CategoryNotifier notifier = GetIt.I.get<CategoryNotifier>();

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
        child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (_, state, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacing.y(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    decoration: InputDecoration(label: Text(strings.description)),
                    textCapitalization: TextCapitalization.sentences,
                    validator: null,
                    onSaved: (String? value) => state.category.description = value ?? '',
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
                  groupValue: state.category.type,
                  onChanged: notifier.setType,
                ),
                RadioListTile<CategoryTypeEnum>(
                  title: Text(CategoryTypeEnum.income.description),
                  value: CategoryTypeEnum.income,
                  groupValue: state.category.type,
                  onChanged: notifier.setType,
                ),
                const Divider(),
                GroupTile(
                  onTap: selectColorAndIcon,
                  title: strings.typeCategory,
                  tile: state.category.color.isNotEmpty && state.category.icon > 0
                      ? ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(state.category.color.toColor() ?? 0),
                            child: Icon(state.category.icon.parseIconData()),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        )
                      : ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: Text(strings.icon),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                ),
                const Divider(),
              ],
            );
          },
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

  Future<void> selectColorAndIcon() async {
    final ({Color color, IconData icon})? result = await ColorAndIconCategory.show(
      context: context,
      color: notifier.value.category.color.isNotEmpty ? Color(notifier.value.category.color.toColor()!) : null,
      icon: IconData(notifier.value.category.icon),
    );
    if (result == null) return;

    notifier.setColorIcon(color: result.color.value.toRadixString(16), icon: result.icon.codePoint);
  }
}
