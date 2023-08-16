import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/category_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/category_state.dart';
import 'package:finan_master_app/features/category/presentation/ui/components/color_and_icon_category.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/group_tile.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class CategoryFormPage extends StatefulWidget {
  static const route = 'category-form';

  final CategoryEntity? category;

  const CategoryFormPage({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> with ThemeContext {
  final CategoryNotifier notifier = GetIt.I.get<CategoryNotifier>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) notifier.updateCategory(widget.category!);
  }

  bool get isLoading => notifier.value is SavingCategoryState || notifier.value is DeletingCategoryState;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, state, __) {
        return SliverScaffold(
          appBar: SliverAppBarMedium(
            title: Text(strings.category),
            loading: isLoading,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
              if (!state.category.isNew)
                IconButton(
                  tooltip: strings.delete,
                  onPressed: delete,
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
                    initialValue: state.category.description,
                    decoration: InputDecoration(label: Text(strings.description)),
                    textCapitalization: TextCapitalization.sentences,
                    validator: InputRequiredValidator().validate,
                    onSaved: (String? value) => state.category.description = value ?? '',
                    enabled: !isLoading,
                  ),
                ),
                const Spacing.y(),
                const Divider(),
                const Spacing.y(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(strings.typeCategory, style: textTheme.bodySmall?.copyWith(color: isLoading ? Theme.of(context).disabledColor : null)),
                ),
                RadioListTile<CategoryTypeEnum>(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(CategoryTypeEnum.expense.description),
                  value: CategoryTypeEnum.expense,
                  groupValue: state.category.type,
                  onChanged: !isLoading ? notifier.setType : null,
                ),
                RadioListTile<CategoryTypeEnum>(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(CategoryTypeEnum.income.description),
                  value: CategoryTypeEnum.income,
                  groupValue: state.category.type,
                  onChanged: !isLoading ? notifier.setType : null,
                ),
                const Divider(),
                GroupTile(
                  onTap: selectColorAndIcon,
                  title: strings.typeCategory,
                  enabled: !isLoading,
                  tile: state.category.color.isNotEmpty && state.category.icon > 0
                      ? ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(state.category.color.toColor() ?? 0),
                            child: Icon(state.category.icon.parseIconData(), color: Colors.white),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          enabled: !isLoading,
                        )
                      : ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: Text(strings.icon),
                          trailing: const Icon(Icons.chevron_right),
                          enabled: !isLoading,
                        ),
                ),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> save() async {
    if (isLoading) return;

    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await notifier.save();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(notifier.category));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (isLoading) return;

    try {
      await notifier.delete();

      if (!mounted) return;
      context.pop(FormResultNavigation<CategoryEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectColorAndIcon() async {
    if (isLoading) return;

    final ({Color color, IconData icon})? result = await ColorAndIconCategory.show(
      context: context,
      color: notifier.category.color.isNotEmpty ? Color(notifier.category.color.toColor()!) : null,
      icon: notifier.category.icon > 0 ? notifier.category.icon.parseIconData() : null,
    );
    if (result == null) return;

    notifier.setColorIcon(color: result.color.value.toRadixString(16), icon: result.icon.codePoint);
  }
}
