import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/fab_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/filters_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/list_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/totals_transactions.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  @override
  void initState() {
    super.initState();

    Future(() async {
      notifier.value = notifier.value.setLoading();

      await categoriesNotifier.findAll();

      if (categoriesNotifier is ErrorCategoriesState) {
        notifier.value = notifier.value.setError((categoriesNotifier.value as ErrorCategoriesState).message);
        return;
      }

      final DateTime dateNow = DateTime.now();
      await notifier.findByPeriod(
        DateTime(dateNow.year, dateNow.month, 1),
        DateTime(dateNow.year, dateNow.month, dateNow.getLastDayInMonth(), 23, 59, 59, 59),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      scaffoldKey: scaffoldKey,
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
      floatingActionButton: const FabTransactions(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (_, TransactionsState state, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacing.y(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FiltersTransactions(notifier: notifier),
                  ),
                  const Spacing.y(),
                  Builder(
                    builder: (_) {
                      return switch (state) {
                        StartTransactionsState _ => const SizedBox.shrink(),
                        LoadingTransactionsState _ => const Center(child: CircularProgressIndicator()),
                        ErrorTransactionsState _ => Text(state.message),
                        EmptyTransactionsState _ => NoContentWidget(child: Text(strings.noTransactionsRegistered)),
                        ListTransactionsState _ => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TotalsTransactions(notifier: notifier),
                              ),
                              const Spacing.y(0.5),
                              ListTransactions(state: state, categories: categoriesNotifier.value.categories),
                            ],
                          ),
                      };
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
