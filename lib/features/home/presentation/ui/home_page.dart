import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_accounts_balance.dart';
import 'package:finan_master_app/features/home/presentation/ui/components/home_card_income.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/components/fab_transactions.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';
import 'package:finan_master_app/shared/presentation/ui/components/dialog/error_dialog.dart';
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
  final AccountsNotifier accountsNotifier = DI.get<AccountsNotifier>();
  final TransactionsNotifier transactionsNotifier = DI.get<TransactionsNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future(() async {
      try {
        await Future.wait([
          accountsNotifier.findAll(deleted: true),
          transactionsNotifier.findByPeriod(transactionsNotifier.startDate, transactionsNotifier.endDate),
        ]);

        eventNotifier.addListener(() {
          if (eventNotifier.value == EventType.transactions) onRefresh();
        });
      } catch (e) {
        if (!mounted) return;
        ErrorDialog.show(context, e.toString());
      }
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
      ),
      drawer: const NavDrawer(),
      floatingActionButton: const FabTransactions(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacing.y(),
                HomeCardAccountsBalance(accountsNotifier: accountsNotifier),
                const Spacing.y(),
                IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: HomeCardMonthlyTransaction.income(transactionsNotifier: transactionsNotifier)),
                      const Spacing.x(),
                      Expanded(child: HomeCardMonthlyTransaction.expense(transactionsNotifier: transactionsNotifier)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {}
}
