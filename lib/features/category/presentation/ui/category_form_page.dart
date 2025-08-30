import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/ui/components/color_and_icon_category.dart';
import 'package:finan_master_app/features/category/presentation/view_models/category_form_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/form/validators/input_required_validator.dart';
import 'package:finan_master_app/shared/presentation/ui/components/group_tile.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar_medium.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryFormPage extends StatefulWidget {
  static const route = 'category-form';

  final CategoryEntity? category;

  const CategoryFormPage({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> with ThemeContext {
  final CategoryFormViewModel viewModel = DI.get<CategoryFormViewModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) viewModel.load(widget.category!.clone());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (_, __) {
        return SliverScaffold(
          appBar: SliverAppBarMedium(
            title: Text(strings.category),
            loading: viewModel.isLoading,
            actions: [
              FilledButton(
                onPressed: save,
                child: Text(strings.save),
              ),
              if (!viewModel.category.isNew)
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
                    initialValue: viewModel.category.description,
                    decoration: InputDecoration(label: Text(strings.description)),
                    textCapitalization: TextCapitalization.sentences,
                    validator: InputRequiredValidator().validate,
                    onSaved: (String? value) => viewModel.category.description = value?.trim() ?? '',
                    enabled: !viewModel.isLoading,
                  ),
                ),
                const Spacing.y(),
                const Divider(),
                const Spacing.y(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(strings.typeCategory, style: textTheme.bodySmall?.copyWith(color: viewModel.isLoading ? Theme.of(context).disabledColor : null)),
                ),
                RadioGroup<CategoryTypeEnum>(
                  groupValue: viewModel.category.type,
                  onChanged: viewModel.setType,
                  child: Column(
                    children: [
                      RadioListTile<CategoryTypeEnum>(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(CategoryTypeEnum.expense.description),
                        value: CategoryTypeEnum.expense,
                        enabled: !viewModel.isLoading,
                      ),
                      RadioListTile<CategoryTypeEnum>(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(CategoryTypeEnum.income.description),
                        value: CategoryTypeEnum.income,
                        enabled: !viewModel.isLoading,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GroupTile(
                  onTap: selectColorAndIcon,
                  title: strings.icon,
                  enabled: !viewModel.isLoading,
                  tile: viewModel.category.color.isNotEmpty && viewModel.category.icon > 0
                      ? ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(viewModel.category.color.toColor() ?? 0),
                            child: Icon(viewModel.category.icon.parseIconData(), color: Colors.white),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          enabled: !viewModel.isLoading,
                        )
                      : ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: Text(strings.selectIcon),
                          trailing: const Icon(Icons.chevron_right),
                          enabled: !viewModel.isLoading,
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
    if (viewModel.isLoading) return;

    try {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await viewModel.save.execute(viewModel.category);
        viewModel.save.throwIfError();

        if (!mounted) return;
        context.pop(FormResultNavigation.save(viewModel.category));
      }
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> delete() async {
    if (viewModel.isLoading) return;

    try {
      await viewModel.delete.execute(viewModel.category);
      viewModel.delete.throwIfError();

      if (!mounted) return;
      context.pop(FormResultNavigation<CategoryEntity>.delete());
    } catch (e) {
      await ErrorDialog.show(context, e.toString());
    }
  }

  Future<void> selectColorAndIcon() async {
    if (viewModel.isLoading) return;

    final ({Color color, IconData icon})? result = await ColorAndIconCategory.show(
      context: context,
      color: viewModel.category.color.isNotEmpty ? Color(viewModel.category.color.toColor()!) : null,
      icon: viewModel.category.icon > 0 ? viewModel.category.icon.parseIconData() : null,
    );
    if (result == null) return;

    viewModel.setColorIcon(color: result.color.toARGB32().toRadixString(16), icon: result.icon.codePoint);
  }
}
