import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transfer_form_page.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/extensions/int_extension.dart';
import 'package:finan_master_app/shared/extensions/string_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab_child.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionsListPage extends StatefulWidget {
  static const String route = 'transactions-list';

  const TransactionsListPage({Key? key}) : super(key: key);

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> with ThemeContext {
  final TransactionsNotifier notifier = GetIt.I.get<TransactionsNotifier>();
  final CategoriesNotifier categoriesNotifier = GetIt.I.get<CategoriesNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late final DateTime dateNow;
  late DateTime dateFiltered;

  Set<CategoryTypeEnum?> filterSelected = {null};

  @override
  void initState() {
    super.initState();

    dateNow = DateTime.now();
    dateFiltered = dateNow;

    Future(() async {
      notifier.value.setLoading();

      await categoriesNotifier.findAll();

      if (categoriesNotifier is ErrorCategoriesState) {
        notifier.value.setError((categoriesNotifier.value as ErrorCategoriesState).message);
        return;
      }

      await categoriesNotifier.findAll();
    });
  }

  Future<void> findTransactions() => notifier.findByPeriod(DateTime(dateFiltered.year, dateFiltered.month, 1), DateTime(dateFiltered.year, dateFiltered.month, dateFiltered.getLastDayInMonth()));

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBarSmall(
        leading: IconButton(
          tooltip: strings.menu,
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(strings.transactions),
        centerTitle: true,
      ),
      drawer: const NavDrawer(),
      floatingActionButton: ExpandableFab(
        iconOpen: const Icon(Icons.add),
        children: [
          ExpandableFabChild(
            icon: const Icon(Icons.arrow_downward_outlined),
            onPressed: goIncomeFormPage,
          ),
          ExpandableFabChild(
            icon: const Icon(Icons.arrow_upward_outlined),
            onPressed: goExpenseFormPage,
          ),
          ExpandableFabChild(
            icon: const Icon(Icons.credit_card_outlined),
            onPressed: () {},
          ),
          ExpandableFabChild(
            icon: const Icon(Icons.move_up_outlined),
            onPressed: goTransferFormPage,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacing.y(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton(
                  multiSelectionEnabled: false,
                  segments: [
                    ButtonSegment<CategoryTypeEnum?>(value: null, label: Text(strings.allFilter)),
                    ButtonSegment<CategoryTypeEnum>(value: CategoryTypeEnum.expense, label: Text(CategoryTypeEnum.expense.descriptionPlural)),
                    ButtonSegment<CategoryTypeEnum>(value: CategoryTypeEnum.income, label: Text(CategoryTypeEnum.income.descriptionPlural)),
                  ],
                  selected: filterSelected,
                  onSelectionChanged: (Set<CategoryTypeEnum?> value) => setState(() => filterSelected = value),
                ),
              ),
              const Spacing.y(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: strings.previous,
                    icon: const Icon(Icons.chevron_left_outlined),
                    onPressed: () => setState(() => dateFiltered = dateFiltered.subtractMonth(1)),
                  ),
                  const Spacing.x(4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 70),
                    child: Column(
                      children: [
                        Text(DateFormat('MMMM', strings.localeName).format(dateFiltered).toString()),
                        if (dateFiltered.year != dateNow.year) Text(dateFiltered.year.toString(), style: textTheme.labelSmall),
                      ],
                    ),
                  ),
                  const Spacing.x(4),
                  IconButton(
                    tooltip: strings.next,
                    icon: const Icon(Icons.chevron_right_outlined),
                    onPressed: () => setState(() => dateFiltered = dateFiltered.addMonth(1)),
                  ),
                ],
              ),
              const Spacing.y(),
              ValueListenableBuilder(
                valueListenable: notifier,
                builder: (_, TransactionsState state, __) {
                  return switch (state) {
                    StartTransactionsState _ => const SizedBox.shrink(),
                    LoadingTransactionsState _ => const Center(child: CircularProgressIndicator()),
                    ErrorTransactionsState _ => Text(state.message),
                    EmptyTransactionsState _ => NoContentWidget(child: Text(strings.noTransactionsRegistered)),
                    ListTransactionsState _ => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Receita mensal", style: textTheme.bodySmall),
                                    Text(2500.0.money, style: textTheme.labelLarge),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Receita mensal", style: textTheme.bodySmall),
                                    Text(2500.0.money, style: textTheme.labelLarge),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacing.y(0.5),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const Divider(),
                            itemCount: state.transactions.length,
                            itemBuilder: (_, index) {
                              final IFinancialOperation transaction = state.transactions[index];

                              return switch (transaction) {
                                ExpenseEntity expense => Builder(
                                    builder: (_) {
                                      final category = categoriesNotifier.value.categories.firstWhere((category) => category.id == expense.idCategory);
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Color(category.color.toColor()!),
                                          child: Icon(category.icon.parseIconData(), color: Colors.white),
                                        ),
                                        title: Text(expense.description),
                                        subtitle: Text(category.description),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(expense.transaction.amount.money, style: textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                                            Text(DateFormat.yMMMMEEEEd().format(expense.transaction.date)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                IncomeEntity income => Builder(
                                    builder: (_) {
                                      final category = categoriesNotifier.value.categories.firstWhere((category) => category.id == income.idCategory);
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Color(category.color.toColor()!),
                                          child: Icon(category.icon.parseIconData(), color: Colors.white),
                                        ),
                                        title: Text(income.description),
                                        subtitle: Text(category.description),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(income.transaction.amount.money, style: textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                                            Text(DateFormat.yMMMMEEEEd().format(income.transaction.date)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                TransferEntity transfer => ListTile(),
                                _ => const SizedBox.shrink(),
                              };
                            },
                          ),
                        ],
                      ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> goExpenseFormPage() async {
    await context.pushNamed(ExpenseFormPage.route);
  }

  Future<void> goIncomeFormPage() async {
    await context.pushNamed(IncomeFormPage.route);
  }

  Future<void> goTransferFormPage() async {
    await context.pushNamed(TransferFormPage.route);
  }
}
