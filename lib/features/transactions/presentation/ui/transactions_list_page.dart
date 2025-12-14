import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/fab_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/filters_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/list_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/totals_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/view_models/transactions_list_view_model.dart';
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
  final TransactionsListViewModel viewModel = DI.get<TransactionsListViewModel>();

  final EventNotifier eventNotifier = DI.get<EventNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<ITransactionEntity> listSelectable = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      final DateTime dateNow = DateTime.now();

      await viewModel.init.execute((startDate: dateNow.getInitialMonth(), endDate: dateNow.getFinalMonth(), filterType: {widget.categoryTypeFilter}));
      viewModel.init.throwIfError();

      eventNotifier.addListener(() {
        if ([EventType.income, EventType.expense, EventType.transfer].contains(eventNotifier.value)) onRefresh();
      });
    });
  }

  Future<void> onRefresh({DateTime? startDate, DateTime? endDate}) async {
    if (viewModel.init.hasError) {
      await viewModel.init.execute((startDate: startDate ?? viewModel.startDate, endDate: endDate ?? viewModel.endDate, filterType: viewModel.filterType));
    } else {
      await viewModel.findByPeriod.execute((startDate: startDate ?? viewModel.startDate, endDate: endDate ?? viewModel.endDate));
    }
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
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ListenableBuilder(
                listenable: Listenable.merge([viewModel, viewModel.init, viewModel.findByPeriod]),
                builder: (_, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacing.y(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: FiltersTransactions(viewModel: viewModel, enabled: listSelectable.isEmpty),
                      ),
                      const Spacing.y(),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: () {
                          final isLoading = viewModel.init.running || viewModel.findByPeriod.running;
                          final hasError = viewModel.init.hasError || viewModel.findByPeriod.hasError;

                          if (isLoading) return const Center(child: CircularProgressIndicator());
                          if (hasError) return MessageErrorWidget(viewModel.init.error?.toString() ?? viewModel.findByPeriod.error?.toString() ?? '');
                          if (viewModel.transactions.isEmpty) return NoContentWidget(child: Text(strings.noTransactionsRegistered));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TotalsTransactions(viewModel: viewModel),
                              ),
                              const Spacing.y(0.5),
                              ListTransactions(viewModel: viewModel),
                            ],
                          );
                        }(),
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
    final DateTime? date = await showDatePickerDefault(context: context, initialDate: viewModel.startDate);

    if (date != null) await onRefresh(startDate: date.getInitialMonth(), endDate: date.getFinalMonth());
  }

  Future<void> deleteTransactions() async {
    try {
      await LoadingDialog.show(
        context: context,
        message: strings.deletingTransactions,
        onAction: () async {
          viewModel.deleteTransactions.execute(listSelectable);
          viewModel.deleteTransactions.throwIfError();
        },
      );

      setState(() {
        listSelectable = [];
        onRefresh();
      });
    } catch (e) {
      if (!mounted) return;
      ErrorDialog.show(context, e.toString());
    }
  }
}
