import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab.dart';
import 'package:finan_master_app/shared/presentation/ui/components/fab/expandable_fab_child.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsListPage extends StatefulWidget {
  static const String route = 'transactions-list';

  const TransactionsListPage({Key? key}) : super(key: key);

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> with ThemeContext {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late final DateTime dateNow;
  late DateTime dateFiltered;

  Set<CategoryTypeEnum?> filterSelected = {null};

  @override
  void initState() {
    super.initState();

    dateNow = DateTime.now();
    dateFiltered = dateNow;
  }

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
            onPressed: () {},
          ),
          ExpandableFabChild(
            icon: const Icon(Icons.arrow_upward_outlined),
            onPressed: () {},
          ),
          ExpandableFabChild(
            icon: const Icon(Icons.credit_card_outlined),
            onPressed: () {},
          ),
          ExpandableFabChild(
            icon: const Icon(Icons.move_up_outlined),
            onPressed: () {},
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
                    onPressed: () => setState(() => dateFiltered = dateFiltered.substractMonth(1)),
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
                itemCount: 2,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.home_repair_service_outlined, color: Colors.white),
                    ),
                    title: Text("Conta de luz"),
                    subtitle: Text("Casa"),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('- ${2500.0.money}', style: textTheme.labelLarge?.copyWith(color: const Color(0XFFFF5454))),
                        Text('Ontem'),
                      ],
                    ),
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
