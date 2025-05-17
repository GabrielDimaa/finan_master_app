import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/category/presentation/ui/category_form_page.dart';
import 'package:finan_master_app/features/category/presentation/ui/components/tab_bar_view_categories.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesListPage extends StatefulWidget {
  static const String route = 'categories-list';
  static const int indexDrawer = 0;

  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> with ThemeContext {
  final CategoriesNotifier notifier = DI.get<CategoriesNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Tab> get tabs => [Tab(text: strings.expenses), Tab(text: strings.incomes)];

  @override
  void initState() {
    super.initState();
    notifier.findAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            tooltip: strings.menu,
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text(strings.categories),
          centerTitle: true,
          bottom: TabBar(tabs: tabs),
        ),
        drawer: const NavDrawer(selectedIndex: CategoriesListPage.indexDrawer),
        floatingActionButton: FloatingActionButton(
          tooltip: strings.createCategory,
          onPressed: goCategory,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (_, CategoriesState state, __) {
              return switch (state) {
                LoadingCategoriesState _ => const Center(child: CircularProgressIndicator()),
                ListCategoriesState _ => TabBarViewCategories(notifier: notifier),
                ErrorCategoriesState state => MessageErrorWidget(state.message),
                EmptyCategoriesState _ => NoContentWidget(child: Text(strings.noCategoryRegistered)),
                StartCategoriesState _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }

  Future<void> goCategory() async {
    final FormResultNavigation<CategoryEntity>? result = await context.pushNamedWithAd(CategoryFormPage.route);
    if (result == null) return;

    notifier.findAll();
  }
}
