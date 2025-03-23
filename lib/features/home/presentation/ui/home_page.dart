import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/first_steps/presentation/notifiers/first_steps_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_accounts_balance_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_bills_credit_card_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_monthly_balance_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_monthly_transaction_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_transactions_unpaid_unreceived_notifier.dart';
import 'package:finan_master_app/features/home/presentation/states/home_transactions_unpaid_unreceived_state.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_alert_first_steps.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_accounts_balance.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_bill_credit_card.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_monthly_balance.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_monthly_transaction.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_transaction_unpaid_unreceived.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/fab_transactions.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transactions_unpaid_unreceived_page.dart';
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
  final EventNotifier eventNotifier = DI.get<EventNotifier>();
  final HomeAccountsBalanceNotifier accountsBalanceNotifier = DI.get<HomeAccountsBalanceNotifier>();
  final HomeMonthlyTransactionNotifier monthlyTransactionNotifier = DI.get<HomeMonthlyTransactionNotifier>();
  final HomeTransactionsUnpaidUnreceivedNotifier transactionUnpaidNotifier = DI.get<HomeTransactionsUnpaidUnreceivedNotifier>();
  final HomeBillsCreditCardNotifier billsCreditCardNotifier = DI.get<HomeBillsCreditCardNotifier>();
  final HomeMonthlyBalanceNotifier monthlyBalanceNotifier = DI.get<HomeMonthlyBalanceNotifier>();
  final FirstStepsNotifier firstStepsNotifier = DI.get<FirstStepsNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    load();

    eventNotifier.addListener(() {
      if ([EventType.income, EventType.expense, EventType.transfer, EventType.creditCard].contains(eventNotifier.value)) load();
    });
  }

  Future<void> load() async {
    await Future.wait([
      accountsBalanceNotifier.load(),
      monthlyTransactionNotifier.load(),
      transactionUnpaidNotifier.load(),
      billsCreditCardNotifier.load(),
      monthlyBalanceNotifier.load(),
    ]);
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
                      HomeCardAccountsBalance(notifier: accountsBalanceNotifier),
                      const Spacing.y(),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: HomeCardMonthlyTransaction.income(notifier: monthlyTransactionNotifier)),
                            const Spacing.x(),
                            Expanded(child: HomeCardMonthlyTransaction.expense(notifier: monthlyTransactionNotifier)),
                          ],
                        ),
                      ),
                      const Spacing.y(),
                      ValueListenableBuilder(
                        valueListenable: transactionUnpaidNotifier,
                        builder: (_, state, __) {
                          if (transactionUnpaidNotifier.value.amountsIncome == 0 && transactionUnpaidNotifier.value.amountsExpense == 0) return const SizedBox.shrink();

                          return Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(child: HomeCardTransactionUnpaidUnreceived.income(notifier: transactionUnpaidNotifier)),
                                    const Spacing.x(),
                                    Expanded(child: HomeCardTransactionUnpaidUnreceived.expense(notifier: transactionUnpaidNotifier)),
                                  ],
                                ),
                              ),
                              const Spacing.y(),
                            ],
                          );
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: billsCreditCardNotifier,
                        builder: (_, __, ___) {
                          if (billsCreditCardNotifier.value.creditCardsWithBill.isEmpty) return const SizedBox.shrink();

                          return Column(
                            children: [
                              HomeCardBillCreditCard(notifier: billsCreditCardNotifier),
                              const Spacing.y(),
                            ],
                          );
                        },
                      ),
                      HomeCardMonthlyBalance(notifier: monthlyBalanceNotifier),
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
    load();
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
