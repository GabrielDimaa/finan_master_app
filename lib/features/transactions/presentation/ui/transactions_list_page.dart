import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/states/categories_state.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/states/transactions_state.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/fab_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/filters_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/list_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/totals_transactions.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';
import 'package:finan_master_app/shared/presentation/ui/components/app_bar_custom.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/date_picker.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/loading_dialog.dart';
import 'package:finan_master_app/shared/presentation/ui/components/list/selectable/list_mode_selectable.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class TransactionsListPage extends StatefulWidget {
  static const String route = 'transactions-list';

  final CategoryTypeEnum? categoryTypeFilter;

  const TransactionsListPage({Key? key, this.categoryTypeFilter}) : super(key: key);

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> with ThemeContext {
  final TransactionsNotifier notifier = DI.get<TransactionsNotifier>();
  final CategoriesNotifier categoriesNotifier = DI.get<CategoriesNotifier>();
  final AccountsNotifier accountsNotifier = DI.get<AccountsNotifier>();
  final EventNotifier eventNotifier = DI.get<EventNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<ITransactionEntity> listSelectable = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      notifier.value = notifier.value.setLoading();

      if (widget.categoryTypeFilter != null) notifier.filterType = {widget.categoryTypeFilter};

      await Future.wait([
        categoriesNotifier.findAll(deleted: true),
        accountsNotifier.findAll(deleted: true),
      ]);

      if (categoriesNotifier is ErrorCategoriesState) {
        notifier.value = notifier.value.setError((categoriesNotifier.value as ErrorCategoriesState).message);
        return;
      }

      if (accountsNotifier is ErrorAccountsState) {
        notifier.value = notifier.value.setError((accountsNotifier.value as ErrorAccountsState).message);
        return;
      }

      eventNotifier.addListener(() {
        if ([EventType.income, EventType.expense, EventType.transfer].contains(eventNotifier.value)) notifier.onRefresh();
      });

      final DateTime dateNow = DateTime.now();
      await notifier.findByPeriod(dateNow.getInitialMonth(), dateNow.getFinalMonth());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListModeSelectable(
      list: listSelectable,
      updateList: (List value) => setState(() => listSelectable = value.cast<ITransactionEntity>()),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBarCustom(
          leading: IconButton(
            tooltip: strings.menu,
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text(strings.transactions),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.today_outlined),
              onPressed: selectDate,
            ),
          ],
          actionsInModeSelection: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: deleteTransactions,
            ),
          ],
        ),
        drawer: const NavDrawer(),
        floatingActionButton: Visibility(
          visible: listSelectable.isEmpty,
          child: const FabTransactions(),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: notifier.onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ValueListenableBuilder(
                valueListenable: notifier,
                builder: (_, TransactionsState state, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacing.y(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: FiltersTransactions(notifier: notifier, enabled: listSelectable.isEmpty),
                      ),
                      const Spacing.y(),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: switch (state) {
                          StartTransactionsState _ => const SizedBox.shrink(),
                          LoadingTransactionsState _ => const Center(child: CircularProgressIndicator()),
                          ErrorTransactionsState _ => MessageErrorWidget(state.message),
                          EmptyTransactionsState _ => NoContentWidget(child: Text(strings.noTransactionsRegistered)),
                          ListTransactionsState _ => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TotalsTransactions(notifier: notifier),
                                ),
                                const Spacing.y(0.5),
                                ListTransactions(
                                  state: state,
                                  categories: categoriesNotifier.value.categories,
                                  accounts: accountsNotifier.value.accounts,
                                  refreshTransactions: notifier.onRefresh,
                                ),
                              ],
                            ),
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    final DateTime? date = await showDatePickerDefault(context: context, initialDate: notifier.startDate);
    if (date != null) {
      await notifier.findByPeriod(date.getInitialMonth(), date.getFinalMonth());
    }
  }

  Future<void> deleteTransactions() async {
    try {
      await LoadingDialog.show(context: context, message: strings.deletingTransactions, onAction: () => notifier.deleteTransactions(listSelectable));

      setState(() {
        listSelectable = [];
        notifier.onRefresh();
      });
    } catch (e) {
      if (!mounted) return;
      ErrorDialog.show(context, e.toString());
    }
  }
}
