import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_details_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/accounts_list_page.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';
import 'package:finan_master_app/features/ad/presentation/ui/pages/ad_page.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/signup_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/ui/email_verification_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/login_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/reset_password_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/signup_page.dart';
import 'package:finan_master_app/features/auth/presentation/ui/signup_password_page.dart';
import 'package:finan_master_app/features/backup/presentation/ui/backup_page.dart';
import 'package:finan_master_app/features/backup/presentation/ui/restore_backup_page.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/presentation/ui/categories_list_page.dart';
import 'package:finan_master_app/features/category/presentation/ui/category_form_page.dart';
import 'package:finan_master_app/features/config/presentation/ui/config_page.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_bill_details_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_bills_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_expense_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_cards_details_page.dart';
import 'package:finan_master_app/features/first_steps/presentation/ui/first_steps_page.dart';
import 'package:finan_master_app/features/home/presentation/ui/home_page.dart';
import 'package:finan_master_app/features/introduction/presentation/ui/introduction_page.dart';
import 'package:finan_master_app/features/reports/presentation/ui/report_categories_page.dart';
import 'package:finan_master_app/features/reports/presentation/ui/reports_page.dart';
import 'package:finan_master_app/features/splash/presentation/ui/splash_page.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/expense_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/income_form_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transactions_list_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transactions_unpaid_unreceived_page.dart';
import 'package:finan_master_app/features/transactions/presentation/ui/transfer_form_page.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_bar_rail.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

sealed class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _transactionsNavigatorKey = GlobalKey<NavigatorState>();
  static final _reportsNavigatorKey = GlobalKey<NavigatorState>();
  static final _configNavigatorKey = GlobalKey<NavigatorState>();

  static RouterConfig<Object> routerConfig() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/${SplashPage.route}',
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: AdPage.route,
          path: '/${AdPage.route}',
          builder: (_, __) => const AdPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: SplashPage.route,
          path: '/${SplashPage.route}',
          builder: (_, __) => const SplashPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: IntroductionPage.route,
          path: '/${IntroductionPage.route}',
          builder: (_, __) => const IntroductionPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: LoginPage.route,
          path: '/${LoginPage.route}',
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: SignupPage.route,
          path: '/${SignupPage.route}',
          builder: (_, __) => const SignupPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: SignupPasswordPage.route,
          path: '/${SignupPasswordPage.route}',
          builder: (_, GoRouterState state) => SignupPasswordPage(notifier: state.extra as SignupNotifier),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: EmailVerificationPage.route,
          path: '/${EmailVerificationPage.route}',
          builder: (_, __) => const EmailVerificationPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: ResetPasswordPage.route,
          path: '/${ResetPasswordPage.route}',
          builder: (_, __) => const ResetPasswordPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: FirstStepsPage.route,
          path: '/${FirstStepsPage.route}',
          builder: (_, GoRouterState state) => FirstStepsPage(firstShowing: state.extra as bool),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: CategoryFormPage.route,
          path: '/${CategoryFormPage.route}',
          builder: (_, GoRouterState state) => CategoryFormPage(category: state.extra as CategoryEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: AccountFormPage.route,
          path: '/${AccountFormPage.route}',
          builder: (_, GoRouterState state) => AccountFormPage(account: state.extra as AccountEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: AccountDetailsPage.route,
          path: '/${AccountDetailsPage.route}',
          builder: (_, GoRouterState state) => AccountDetailsPage(account: state.extra as AccountEntity),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: ExpenseFormPage.route,
          path: '/${ExpenseFormPage.route}',
          builder: (_, GoRouterState state) => ExpenseFormPage(expense: state.extra as ExpenseEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: IncomeFormPage.route,
          path: '/${IncomeFormPage.route}',
          builder: (_, GoRouterState state) => IncomeFormPage(income: state.extra as IncomeEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: TransferFormPage.route,
          path: '/${TransferFormPage.route}',
          builder: (_, GoRouterState state) => TransferFormPage(transfer: state.extra as TransferEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: CreditCardFormPage.route,
          path: '/${CreditCardFormPage.route}',
          builder: (_, GoRouterState state) => CreditCardFormPage(creditCard: state.extra as CreditCardEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: CreditCardExpensePage.route,
          path: '/${CreditCardExpensePage.route}',
          builder: (_, GoRouterState state) => CreditCardExpensePage(creditCardExpense: state.extra as CreditCardTransactionEntity?),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: CreditCardBillDetailsPage.route,
          path: '/${CreditCardBillDetailsPage.route}',
          builder: (_, GoRouterState state) => CreditCardBillDetailsPage(args: state.extra as CreditCardBillDetailsArgsPage),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: CreditCardBillsPage.route,
          path: '/${CreditCardBillsPage.route}',
          builder: (_, GoRouterState state) => CreditCardBillsPage(creditCard: state.extra as CreditCardEntity),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: RestoreBackupPage.route,
          path: '/${RestoreBackupPage.route}',
          builder: (_, GoRouterState state) => const RestoreBackupPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: BackupPage.route,
          path: '/${BackupPage.route}',
          builder: (_, __) => const BackupPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: ReportCategoriesPage.route,
          path: '/${ReportCategoriesPage.route}',
          builder: (_, __) => const ReportCategoriesPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: TransactionsUnpaidUnreceivedPage.route,
          path: '/${TransactionsUnpaidUnreceivedPage.route}',
          builder: (_, GoRouterState state) => TransactionsUnpaidUnreceivedPage(categoryType: state.extra as CategoryTypeEnum),
        ),
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __, navigationShell) => NavBarRail(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _homeNavigatorKey,
                  name: HomePage.route,
                  path: '/${HomePage.route}',
                  builder: (_, __) => const HomePage(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _homeNavigatorKey,
                      name: CategoriesListPage.route,
                      path: CategoriesListPage.route,
                      builder: (_, __) => const CategoriesListPage(),
                    ),
                    GoRoute(
                      parentNavigatorKey: _homeNavigatorKey,
                      name: CreditCardsDetailsPage.route,
                      path: CreditCardsDetailsPage.route,
                      builder: (_, GoRouterState state) => CreditCardsDetailsPage(key: ObjectKey(state.extra), idCreditCard: state.extra as String?),
                    ),
                    GoRoute(
                      parentNavigatorKey: _homeNavigatorKey,
                      name: AccountsListPage.route,
                      path: AccountsListPage.route,
                      builder: (_, __) => const AccountsListPage(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _transactionsNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _transactionsNavigatorKey,
                  name: TransactionsListPage.route,
                  path: '/${TransactionsListPage.route}',
                  builder: (_, GoRouterState state) => TransactionsListPage(key: ObjectKey(state.extra), categoryTypeFilter: state.extra as CategoryTypeEnum?),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _reportsNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _reportsNavigatorKey,
                  name: ReportsPage.route,
                  path: '/${ReportsPage.route}',
                  builder: (_, __) => const ReportsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _configNavigatorKey,
              routes: [
                GoRoute(
                  parentNavigatorKey: _configNavigatorKey,
                  name: ConfigPage.route,
                  path: '/${ConfigPage.route}',
                  builder: (_, __) => const ConfigPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

extension GoRouterExtension on BuildContext {
  Future<T?> pushNamedWithAd<T extends Object?>(String name, {Object? extra}) async {
    if (!mounted) throw Exception('Context not mounted.');

    final IAdAccess adAccess = DI.get<IAdAccess>();
    final IAd ad = DI.get<IAd>();

    if (adAccess.canShowAd() && ad.hasInterstitialAd) await pushNamed(AdPage.route);

    return pushNamed(name, extra: extra);
  }
}
