import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/list_recent_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/fab_transactions.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  static const String route = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ThemeContext {
  final TransactionsNotifier notifier = GetIt.I.get<TransactionsNotifier>();
  final EventNotifier eventNotifier = GetIt.I.get<EventNotifier>();
  final CategoriesNotifier categoriesNotifier = GetIt.I.get<CategoriesNotifier>();
  final AccountsNotifier accountsNotifier = GetIt.I.get<AccountsNotifier>();
  final ValueNotifier<bool> initialLoadingNotifier = ValueNotifier(true);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        await Future.wait([
          notifier.findByPeriod(notifier.startDate, notifier.endDate),
          categoriesNotifier.findAll(deleted: true),
          accountsNotifier.findAll(deleted: true),
        ]);

        if (notifier is ErrorTransactionsState) throw Exception((notifier.value as ErrorTransactionsState).message);

        if (categoriesNotifier is ErrorCategoriesState) throw Exception((categoriesNotifier.value as ErrorCategoriesState).message);

        if (accountsNotifier is ErrorAccountsState) throw Exception((accountsNotifier.value as ErrorAccountsState).message);

        eventNotifier.addListener(() {
          if (eventNotifier.value == EventType.transactions) notifier.refreshTransactions();
        });
      } catch (e) {
        if (!mounted) return;
        ErrorDialog.show(context, e.toString());
      } finally {
        initialLoadingNotifier.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: initialLoadingNotifier,
      builder: (_, loading, __) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              tooltip: strings.menu,
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
            title: Text(strings.home),
            centerTitle: true,
          ),
          drawer: const NavDrawer(),
          floatingActionButton: FabTransactions(notifier: notifier),
          body: SafeArea(
            child: Builder(
              builder: (_) {
                if (loading) return const Center(child: CircularProgressIndicator());

                return RefreshIndicator(
                  onRefresh: notifier.refreshTransactions,
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder(
                      valueListenable: notifier,
                      builder: (_, state, __) {
                        return Column(
                          children: [
                            const Spacing.y(),
                            Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              elevation: 0,
                              color: colorScheme.primary.withAlpha(12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(strings.accountsBalance, style: textTheme.labelMedium),
                                      const Spacing.y(0.5),
                                      Text(accountsNotifier.accountsBalance.money, style: textTheme.headlineLarge),
                                      const Spacing.y(2),
                                      ButtonBar(
                                        buttonPadding: EdgeInsets.zero,
                                        alignment: MainAxisAlignment.spaceBetween,
                                        overflowButtonSpacing: 12,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF3CDE87).withAlpha(30),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(Icons.arrow_upward_outlined, color: Color(0xFF3CDE87)),
                                              ),
                                              const Spacing.x(0.5),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(strings.incomes, style: textTheme.labelSmall),
                                                  Text(notifier.transactionsByPeriod.amountsIncome.money, style: textTheme.labelLarge),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF5454).withAlpha(30),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(Icons.arrow_downward_outlined, color: Color(0xFFFF5454)),
                                              ),
                                              const Spacing.x(0.5),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(strings.expenses, style: textTheme.labelSmall),
                                                  Text(notifier.transactionsByPeriod.amountsExpense.abs().money, style: textTheme.labelLarge),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacing.y(3),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(strings.recentTransactions, style: textTheme.titleMedium),
                              ),
                            ),
                            const Spacing.y(),
                            Visibility(
                              visible: state.transactions.isNotEmpty,
                              replacement: SizedBox(
                                width: MediaQuery.sizeOf(context).width / 1.5,
                                child: NoContentWidget(
                                  child: Text(strings.noTransactionsRegistered),
                                ),
                              ),
                              child: ListRecentTransactions(
                                state: state,
                                categories: categoriesNotifier.value.categories,
                                accounts: accountsNotifier.value.accounts,
                              ),
                            ),
                            const Spacing.y(5),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
