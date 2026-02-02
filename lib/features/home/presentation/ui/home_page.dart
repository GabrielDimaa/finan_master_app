import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/first_steps/presentation/notifiers/first_steps_notifier.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_alert_first_steps.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_accounts_balance.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_bill_credit_card.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_monthly_balance.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_monthly_transaction.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_transaction_unpaid_unreceived.dart';
import 'package:finan_master_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/fab_transactions.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String route = 'home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ThemeContext {
  final HomeViewModel viewModel = DI.get<HomeViewModel>();

  final EventNotifier eventNotifier = DI.get<EventNotifier>();
  final FirstStepsNotifier firstStepsNotifier = DI.get<FirstStepsNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    viewModel.initialize();

    eventNotifier.addListener(() {
      if ([EventType.income, EventType.expense, EventType.transfer, EventType.creditCard].contains(eventNotifier.value)) viewModel.load();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (_, __) {
              if (viewModel.hideAmounts) {
                return IconButton(
                  icon: const Icon(Icons.visibility_off_outlined),
                  onPressed: viewModel.toggleHideAmounts,
                );
              }

              return IconButton(
                icon: const Icon(Icons.visibility_outlined),
                onPressed: viewModel.toggleHideAmounts,
              );
            },
          ),
        ],
      ),
      drawer: const NavDrawer(),
      floatingActionButton: const FabTransactions(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            children: [
              HomeAlertFirstSteps(notifier: firstStepsNotifier),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacing.y(),
                      HomeCardAccountsBalance(viewModel: viewModel),
                      const Spacing.y(),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: HomeCardMonthlyTransaction.income(viewModel: viewModel)),
                            const Spacing.x(),
                            Expanded(child: HomeCardMonthlyTransaction.expense(viewModel: viewModel)),
                          ],
                        ),
                      ),
                      const Spacing.y(),
                      ListenableBuilder(
                        listenable: viewModel.loadTransactionsUnpaidUnreceived,
                        builder: (_, __) {
                          if (viewModel.loadTransactionsUnpaidUnreceived.running) {
                            if (viewModel.loadTransactionsUnpaidUnreceived.previous?.error == null && (viewModel.loadTransactionsUnpaidUnreceived.previous?.result?.amountsIncome ?? 0) == 0 && (viewModel.loadTransactionsUnpaidUnreceived.previous?.result?.amountsExpense ?? 0) == 0) return const SizedBox.shrink();
                          } else if (viewModel.loadTransactionsUnpaidUnreceived.completed && (viewModel.loadTransactionsUnpaidUnreceived.result?.amountsIncome ?? 0) == 0 && (viewModel.loadTransactionsUnpaidUnreceived.result?.amountsExpense ?? 0) == 0) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(child: HomeCardTransactionUnpaidUnreceived.income(viewModel: viewModel)),
                                    const Spacing.x(),
                                    Expanded(child: HomeCardTransactionUnpaidUnreceived.expense(viewModel: viewModel)),
                                  ],
                                ),
                              ),
                              const Spacing.y(),
                            ],
                          );
                        },
                      ),
                      ListenableBuilder(
                        listenable: viewModel.loadBillsCreditCard,
                        builder: (_, __) {
                          if (viewModel.loadBillsCreditCard.running) {
                            if (viewModel.loadBillsCreditCard.previous?.error == null && viewModel.loadBillsCreditCard.previous?.result?.isEmpty != false) return const SizedBox.shrink();
                          } else if (viewModel.loadBillsCreditCard.completed && viewModel.loadBillsCreditCard.result?.isEmpty != false) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              HomeCardBillCreditCard(viewModel: viewModel),
                              const Spacing.y(),
                            ],
                          );
                        },
                      ),
                      HomeCardMonthlyBalance(viewModel: viewModel),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    viewModel.load();
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
