import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_find.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_readjustment_transaction.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_save.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_readjustment_transaction.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/account/infra/data_sources/account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/repositories/account_repository.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/account_notifier.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/auth_find.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_auth_find.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_login_auth.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_reset_password.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/i_signup_auth.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/login_auth.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/reset_password.dart';
import 'package:finan_master_app/features/auth/domain/use_cases/signup_auth.dart';
import 'package:finan_master_app/features/auth/infra/data_sources/auth_local_data_source.dart';
import 'package:finan_master_app/features/auth/infra/data_sources/i_auth_local_data_source.dart';
import 'package:finan_master_app/features/auth/infra/repositories/auth_repository.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/email_verification_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/reset_password_notifier.dart';
import 'package:finan_master_app/features/auth/presentation/notifiers/signup_notifier.dart';
import 'package:finan_master_app/features/backup/domain/repositories/i_backup_repository.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/backup.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/i_backup.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/i_restore_backup.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/restore_backup.dart';
import 'package:finan_master_app/features/backup/infra/repositories/backup_repository.dart';
import 'package:finan_master_app/features/backup/presentation/notifiers/backup_notifier.dart';
import 'package:finan_master_app/features/category/domain/repositories/i_category_repository.dart';
import 'package:finan_master_app/features/category/domain/use_cases/category_delete.dart';
import 'package:finan_master_app/features/category/domain/use_cases/category_find.dart';
import 'package:finan_master_app/features/category/domain/use_cases/category_save.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_delete.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_save.dart';
import 'package:finan_master_app/features/category/infra/data_sources/category_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/repositories/category_repository.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/categories_notifier.dart';
import 'package:finan_master_app/features/category/presentation/notifiers/category_notifier.dart';
import 'package:finan_master_app/features/config/domain/repositories/i_config_repository.dart';
import 'package:finan_master_app/features/config/domain/use_cases/config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/config_save.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:finan_master_app/features/config/infra/repositories/config_repository.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/locale_notifier.dart';
import 'package:finan_master_app/features/config/presentation/notifiers/theme_mode_notifier.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_bill_dates.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_bill_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_bill_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_dates.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/repositories/credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/infra/repositories/credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/infra/repositories/credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_bill_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_bills_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_expense_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_cards_notifier.dart';
import 'package:finan_master_app/features/first_steps/domain/repositories/i_first_steps_repository.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/first_steps_find.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/first_steps_save.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/i_first_steps_find.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/i_first_steps_save.dart';
import 'package:finan_master_app/features/first_steps/infra/data_sources/first_steps_local_data_source.dart';
import 'package:finan_master_app/features/first_steps/infra/data_sources/i_first_steps_local_data_source.dart';
import 'package:finan_master_app/features/first_steps/infra/repositories/first_steps_repository.dart';
import 'package:finan_master_app/features/first_steps/presentation/notifiers/first_steps_notifier.dart';
import 'package:finan_master_app/features/home/domain/repositories/i_home_monthly_balance_repository.dart';
import 'package:finan_master_app/features/home/domain/usecases/home_monthly_balance.dart';
import 'package:finan_master_app/features/home/domain/usecases/i_home_monthly_balance.dart';
import 'package:finan_master_app/features/home/infra/repositories/home_monthly_balance_repository.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_accounts_balance_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_bills_credit_card_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_monthly_balance_notifier.dart';
import 'package:finan_master_app/features/home/presentation/notifiers/home_monthly_transaction_notifier.dart';
import 'package:finan_master_app/features/reports/domain/repositories/i_report_categories_repository.dart';
import 'package:finan_master_app/features/reports/domain/use_cases/i_report_categories_find.dart';
import 'package:finan_master_app/features/reports/domain/use_cases/report_categories_find.dart';
import 'package:finan_master_app/features/reports/infra/repositories/report_categories_repository.dart';
import 'package:finan_master_app/features/reports/presentation/notifiers/report_categories_notifier.dart';
import 'package:finan_master_app/features/splash/presentation/notifiers/splash_notifier.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/statement/infra/data_sources/i_statement_local_data_source.dart';
import 'package:finan_master_app/features/statement/infra/data_sources/statement_local_data_source.dart';
import 'package:finan_master_app/features/statement/infra/repositories/statement_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/expense_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/income_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/income_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/transaction_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/transaction_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/transfer_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/transfer_save.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/repositories/expense_repository.dart';
import 'package:finan_master_app/features/transactions/infra/repositories/income_repository.dart';
import 'package:finan_master_app/features/transactions/infra/repositories/transfer_repository.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/expense_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/income_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transfer_notifier.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/i_user_account_cloud_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/i_user_account_local_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/user_account_cloud_data_source.dart';
import 'package:finan_master_app/features/user_account/infra/data_sources/user_account_local_data_source.dart';
import 'package:finan_master_app/shared/classes/env.dart';
import 'package:finan_master_app/shared/domain/domain/delete_app_data.dart';
import 'package:finan_master_app/shared/domain/domain/i_delete_app_data.dart';
import 'package:finan_master_app/shared/domain/repositories/i_delete_app_data_repository.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/auth_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/auth/i_auth_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/crypt/crypt_aes.dart';
import 'package:finan_master_app/shared/infra/drivers/crypt/i_crypt_aes.dart';
import 'package:finan_master_app/shared/infra/drivers/file_picker/file_picker_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/file_picker/i_file_picker_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/share/i_share_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/share/share_driver.dart';
import 'package:finan_master_app/shared/infra/repositories/delete_app_data_repository.dart';
import 'package:finan_master_app/shared/infra/repositories/local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';
import 'package:finan_master_app/shared/presentation/ui/app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependencyInjection {
  static DependencyInjection? _instance;

  DependencyInjection._();

  factory DependencyInjection() => _instance ??= DependencyInjection._();

  Future<void> setup() async {
    final GetIt getIt = GetIt.I;

    //Data Sources
    late final DatabaseLocal databaseLocal;
    late final SharedPreferences sharedPreferences;
    await Future.wait([
      Firebase.initializeApp(
        name: appName,
        options: const FirebaseOptions(
          apiKey: Env.firebaseApiKey,
          appId: Env.firebaseAppId,
          messagingSenderId: Env.firebaseMessagingSenderId,
          projectId: Env.firebaseProjectId,
          storageBucket: Env.firebaseStorageBucket,
        ),
      ),
      Future(() async => databaseLocal = await DatabaseLocal.getInstance()),
      Future(() async => sharedPreferences = await SharedPreferences.getInstance()),
    ]);

    getIt.registerSingleton<EventNotifier>(EventNotifier());

    //Drivers
    getIt.registerFactory<IFilePickerDriver>(() => FilePickerDriver());
    getIt.registerFactory<IShareDriver>(() => ShareDriver());
    getIt.registerFactory<ICryptAES>(() => CryptAES());
    getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    getIt.registerSingleton<GoogleSignIn>(GoogleSignIn());

    getIt.registerSingleton<IDatabaseLocal>(databaseLocal);
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerFactory<ICacheLocal>(() => CacheLocal(sharedPreferences: sharedPreferences));

    getIt.registerFactory<IAccountLocalDataSource>(() => AccountLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<IAuthLocalDataSource>(() => AuthLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<IAuthDriver>(() => AuthDriver(firebaseAuth: getIt.get<FirebaseAuth>(), googleSignIn: getIt.get<GoogleSignIn>(), cryptAES: getIt.get<ICryptAES>()));
    getIt.registerFactory<ICategoryLocalDataSource>(() => CategoryLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ICreditCardTransactionLocalDataSource>(() => CreditCardTransactionLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ICreditCardBillLocalDataSource>(() => CreditCardBillLocalDataSource(databaseLocal: databaseLocal, creditCardTransactionLocalDataSource: getIt.get<ICreditCardTransactionLocalDataSource>()));
    getIt.registerFactory<ICreditCardLocalDataSource>(() => CreditCardLocalDataSource(databaseLocal: databaseLocal, creditCardBillLocalDataSource: getIt.get<ICreditCardBillLocalDataSource>()));
    getIt.registerFactory<IExpenseLocalDataSource>(() => ExpenseLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<IFirstStepsLocalDataSource>(() => FirstStepsLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<IIncomeLocalDataSource>(() => IncomeLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ITransferLocalDataSource>(() => TransferLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<IUserAccountLocalDataSource>(() => UserAccountLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<IUserAccountCloudDataSource>(() => UserAccountCloudDataSource(firestore: getIt.get<FirebaseFirestore>()));
    getIt.registerFactory<IStatementLocalDataSource>(() => StatementLocalDataSource(databaseLocal: databaseLocal));

    //Repositories
    getIt.registerFactory<IAccountRepository>(() => AccountRepository(dataSource: getIt.get<IAccountLocalDataSource>(), creditCardLocalDataSource: getIt.get<ICreditCardLocalDataSource>(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<IAuthRepository>(() => AuthRepository(authDataSource: getIt.get<IAuthLocalDataSource>(), userAccountLocalDataSource: getIt.get<IUserAccountLocalDataSource>(), userAccountCloudDataSource: getIt.get<IUserAccountCloudDataSource>(), authDriver: getIt.get<IAuthDriver>(), databaseLocalTransaction: databaseLocal.transactionInstance(), cryptAES: getIt.get<ICryptAES>()));
    getIt.registerFactory<IBackupRepository>(() => BackupRepository(databaseLocal: databaseLocal, cacheLocal: getIt.get<ICacheLocal>(), shareDriver: getIt.get<IShareDriver>(), filePickerDriver: getIt.get<IFilePickerDriver>()));
    getIt.registerFactory<ICategoryRepository>(() => CategoryRepository(dataSource: getIt.get<ICategoryLocalDataSource>()));
    getIt.registerFactory<IConfigRepository>(() => ConfigRepository(cacheLocal: getIt.get<ICacheLocal>()));
    getIt.registerFactory<ICreditCardRepository>(() => CreditCardRepository(creditCardDataSource: getIt.get<ICreditCardLocalDataSource>(), accountDataSource: getIt.get<IAccountLocalDataSource>(), billDataSource: getIt.get<ICreditCardBillLocalDataSource>(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<ICreditCardBillRepository>(() => CreditCardBillRepository(localDataSource: getIt.get<ICreditCardBillLocalDataSource>(), creditCardTransactionLocalDataSource: getIt.get<ICreditCardTransactionLocalDataSource>(), dbTransaction: databaseLocal.transactionInstance(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<ICreditCardTransactionRepository>(() => CreditCardTransactionRepository(dataSource: getIt.get<ICreditCardTransactionLocalDataSource>(), expenseDataSource: getIt.get<IExpenseLocalDataSource>(), statementDataSource: getIt.get<IStatementLocalDataSource>(), dbTransaction: databaseLocal.transactionInstance(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<IDeleteAppDataRepository>(() => DeleteAppDataRepository(databaseLocal: databaseLocal, cacheLocal: getIt.get<ICacheLocal>(), authDriver: getIt.get<IAuthDriver>()));
    getIt.registerFactory<IExpenseRepository>(() => ExpenseRepository(expenseLocalDataSource: getIt.get<IExpenseLocalDataSource>(), dbTransaction: databaseLocal.transactionInstance(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<IFirstStepsRepository>(() => FirstStepsRepository(dataSource: getIt.get<IFirstStepsLocalDataSource>()));
    getIt.registerFactory<IHomeMonthlyBalanceRepository>(() => HomeMonthlyBalanceRepository(dataSource: getIt.get<IStatementLocalDataSource>()));
    getIt.registerFactory<IIncomeRepository>(() => IncomeRepository(incomeLocalDataSource: getIt.get<IIncomeLocalDataSource>(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<ILocalDBTransactionRepository>(() => LocalDBTransactionRepository(databaseLocalTransaction: databaseLocal.transactionInstance()));
    getIt.registerFactory<IReportCategoriesRepository>(() => ReportCategoriesRepository(expenseLocalDataSource: getIt.get<IExpenseLocalDataSource>(), incomeLocalDataSource: getIt.get<IIncomeLocalDataSource>(), categoriesLocalDataSource: getIt.get<ICategoryLocalDataSource>()));
    getIt.registerFactory<ITransferRepository>(() => TransferRepository(transferLocalDataSource: getIt.get<ITransferLocalDataSource>(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<IStatementRepository>(() => StatementRepository(dataSource: getIt.get<IStatementLocalDataSource>(), dbTransaction: databaseLocal.transactionInstance()));

    //Use cases
    getIt.registerFactory<IAccountDelete>(() => AccountDelete(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAccountFind>(() => AccountFind(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAccountReadjustmentTransaction>(() => AccountReadjustmentTransaction(incomeSave: getIt.get<IIncomeSave>(), expenseSave: getIt.get<IExpenseSave>(), repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAccountSave>(() => AccountSave(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAuthFind>(() => AuthFind(repository: getIt.get<IAuthRepository>()));
    getIt.registerFactory<IBackup>(() => Backup(repository: getIt.get<IBackupRepository>()));
    getIt.registerFactory<ICategoryDelete>(() => CategoryDelete(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategoryFind>(() => CategoryFind(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategorySave>(() => CategorySave(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<IConfigFind>(() => ConfigFind(repository: getIt.get<IConfigRepository>()));
    getIt.registerFactory<IConfigSave>(() => ConfigSave(repository: getIt.get<IConfigRepository>()));
    getIt.registerFactory<ICreditCardDelete>(() => CreditCardDelete(repository: getIt.get<ICreditCardRepository>()));
    getIt.registerFactory<ICreditCardFind>(() => CreditCardFind(repository: getIt.get<ICreditCardRepository>()));
    getIt.registerFactory<ICreditCardSave>(() => CreditCardSave(creditCardBillDates: getIt.get<ICreditCardBillDates>(), repository: getIt.get<ICreditCardRepository>(), creditCardBillRepository: getIt.get<ICreditCardBillRepository>(), creditCardTransactionRepository: getIt.get<ICreditCardTransactionRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<ICreditCardBillFind>(() => CreditCardBillFind(repository: getIt.get<ICreditCardBillRepository>()));
    getIt.registerFactory<ICreditCardBillSave>(() => CreditCardBillSave(repository: getIt.get<ICreditCardBillRepository>(), creditCardTransactionRepository: getIt.get<ICreditCardTransactionRepository>(), creditCardRepository: getIt.get<ICreditCardRepository>(), expenseRepository: getIt.get<IExpenseRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>(), statementRepository: getIt.get<IStatementRepository>()));
    getIt.registerFactory<ICreditCardTransactionDelete>(() => CreditCardTransactionDelete(repository: getIt.get<ICreditCardTransactionRepository>(), expenseRepository: getIt.get<IExpenseRepository>(), statementRepository: getIt.get<IStatementRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<ICreditCardTransactionSave>(() => CreditCardTransactionSave(creditCardBillDates: getIt.get<ICreditCardBillDates>(), repository: getIt.get<ICreditCardRepository>(), creditCardBillRepository: getIt.get<ICreditCardBillRepository>(), creditCardTransactionRepository: getIt.get<ICreditCardTransactionRepository>()));
    getIt.registerFactory<IDeleteAppData>(() => DeleteAppData(repository: getIt.get<IDeleteAppDataRepository>()));
    getIt.registerFactory<IExpenseDelete>(() => ExpenseDelete(repository: getIt.get<IExpenseRepository>(), statementRepository: getIt.get<IStatementRepository>(), creditCardTransactionRepository: getIt.get<ICreditCardTransactionRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<IExpenseSave>(() => ExpenseSave(repository: getIt.get<IExpenseRepository>(), statementRepository: getIt.get<IStatementRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<IExpenseFind>(() => ExpenseFind(repository: getIt.get<IExpenseRepository>()));
    getIt.registerFactory<IFirstStepsFind>(() => FirstStepsFind(repository: getIt.get<IFirstStepsRepository>()));
    getIt.registerFactory<IFirstStepsSave>(() => FirstStepsSave(repository: getIt.get<IFirstStepsRepository>()));
    getIt.registerFactory<IHomeMonthlyBalance>(() => HomeMonthlyBalance(repository: getIt.get<IHomeMonthlyBalanceRepository>()));
    getIt.registerFactory<IIncomeDelete>(() => IncomeDelete(repository: getIt.get<IIncomeRepository>(), statementRepository: getIt.get<IStatementRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<IIncomeSave>(() => IncomeSave(repository: getIt.get<IIncomeRepository>(), statementRepository: getIt.get<IStatementRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<IIncomeFind>(() => IncomeFind(repository: getIt.get<IIncomeRepository>()));
    getIt.registerFactory<ICreditCardBillDates>(() => CreditCardBillDates());
    getIt.registerFactory<ILoginAuth>(() => LoginAuth(repository: getIt.get<IAuthRepository>()));
    getIt.registerFactory<IReportCategoriesFind>(() => ReportCategoriesFind(repository: getIt.get<IReportCategoriesRepository>()));
    getIt.registerFactory<IResetPassword>(() => ResetPassword(repository: getIt.get<IAuthRepository>()));
    getIt.registerFactory<IRestoreBackup>(() => RestoreBackup(repository: getIt.get<IBackupRepository>()));
    getIt.registerFactory<ISignupAuth>(() => SignupAuth(repository: getIt.get<IAuthRepository>()));
    getIt.registerFactory<ITransactionFind>(() => TransactionFind(expenseRepository: getIt.get<IExpenseRepository>(), incomeRepository: getIt.get<IIncomeRepository>(), transferRepository: getIt.get<ITransferRepository>()));
    getIt.registerFactory<ITransactionDelete>(() => TransactionDelete(incomeDelete: getIt.get<IIncomeDelete>(), expenseDelete: getIt.get<IExpenseDelete>(), transferDelete: getIt.get<ITransferDelete>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<ITransferDelete>(() => TransferDelete(repository: getIt.get<ITransferRepository>(), statementRepository: getIt.get<IStatementRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<ITransferSave>(() => TransferSave(repository: getIt.get<ITransferRepository>(), statementRepository: getIt.get<IStatementRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));

    //Notifiers
    getIt.registerFactory<AccountNotifier>(() => AccountNotifier(accountFind: getIt.get<IAccountFind>(), accountSave: getIt.get<IAccountSave>(), accountDelete: getIt.get<IAccountDelete>(), accountReadjustmentTransaction: getIt.get<IAccountReadjustmentTransaction>()));
    getIt.registerFactory<AccountsNotifier>(() => AccountsNotifier(accountFind: getIt.get<IAccountFind>()));
    getIt.registerFactory<HomeAccountsBalanceNotifier>(() => HomeAccountsBalanceNotifier(accountFind: getIt.get<IAccountFind>()));
    getIt.registerFactory<HomeBillsCreditCardNotifier>(() => HomeBillsCreditCardNotifier(creditCardFind: getIt.get<ICreditCardFind>()));
    getIt.registerFactory<HomeMonthlyBalanceNotifier>(() => HomeMonthlyBalanceNotifier(monthlyBalance: getIt.get<IHomeMonthlyBalance>()));
    getIt.registerFactory<HomeMonthlyTransactionNotifier>(() => HomeMonthlyTransactionNotifier(transactionFind: getIt.get<ITransactionFind>()));
    getIt.registerFactory<BackupNotifier>(() => BackupNotifier(backup: getIt.get<IBackup>(), restoreBackup: getIt.get<IRestoreBackup>(), deleteAppData: getIt.get<IDeleteAppData>()));
    getIt.registerFactory<CategoriesNotifier>(() => CategoriesNotifier(categoryFind: getIt.get<ICategoryFind>()));
    getIt.registerFactory<CategoryNotifier>(() => CategoryNotifier(categorySave: getIt.get<ICategorySave>(), categoryDelete: getIt.get<ICategoryDelete>()));
    getIt.registerFactory<CreditCardNotifier>(() => CreditCardNotifier(creditCardSave: getIt.get<ICreditCardSave>(), creditCardDelete: getIt.get<ICreditCardDelete>(), creditCardFind: getIt.get<ICreditCardFind>()));
    getIt.registerFactory<CreditCardExpenseNotifier>(() => CreditCardExpenseNotifier(creditCardTransactionSave: getIt.get<ICreditCardTransactionSave>(), creditCardTransactionDelete: getIt.get<ICreditCardTransactionDelete>(), expenseFind: getIt.get<IExpenseFind>()));
    getIt.registerFactory<CreditCardsNotifier>(() => CreditCardsNotifier(creditCardFind: getIt.get<ICreditCardFind>()));
    getIt.registerFactory<CreditCardBillNotifier>(() => CreditCardBillNotifier(creditCardBillFind: getIt.get<ICreditCardBillFind>(), creditCardBillSave: getIt.get<ICreditCardBillSave>(), creditCardTransactionDelete: getIt.get<ICreditCardTransactionDelete>()));
    getIt.registerFactory<CreditCardBillsNotifier>(() => CreditCardBillsNotifier(creditCardBillFind: getIt.get<ICreditCardBillFind>()));
    getIt.registerSingleton<EmailVerificationNotifier>(EmailVerificationNotifier(signupAuth: getIt.get<ISignupAuth>()));
    getIt.registerFactory<ExpenseNotifier>(() => ExpenseNotifier(expenseSave: getIt.get<IExpenseSave>(), expenseDelete: getIt.get<IExpenseDelete>(), expenseFind: getIt.get<IExpenseFind>()));
    getIt.registerSingleton<FirstStepsNotifier>(FirstStepsNotifier(firstStepsFind: getIt.get<IFirstStepsFind>(), firstStepsSave: getIt.get<IFirstStepsSave>(), eventNotifier: getIt.get<EventNotifier>()));
    getIt.registerFactory<IncomeNotifier>(() => IncomeNotifier(incomeSave: getIt.get<IIncomeSave>(), incomeDelete: getIt.get<IIncomeDelete>(), incomeFind: getIt.get<IIncomeFind>()));
    getIt.registerSingleton<LocaleNotifier>(LocaleNotifier(configFind: getIt.get<IConfigFind>(), configSave: getIt.get<IConfigSave>()));
    getIt.registerFactory<LoginNotifier>(() => LoginNotifier(loginAuth: getIt.get<ILoginAuth>()));
    getIt.registerFactory<ReportCategoriesNotifier>(() => ReportCategoriesNotifier(getIt.get<IReportCategoriesFind>()));
    getIt.registerFactory<ResetPasswordNotifier>(() => ResetPasswordNotifier(getIt.get<IResetPassword>()));
    getIt.registerFactory<SignupNotifier>(() => SignupNotifier(signupAuth: getIt.get<ISignupAuth>()));
    getIt.registerFactory<SplashNotifier>(() => SplashNotifier(authFind: getIt.get<IAuthFind>()));
    getIt.registerSingleton<ThemeModeNotifier>(ThemeModeNotifier(configFind: getIt.get<IConfigFind>(), configSave: getIt.get<IConfigSave>()));
    getIt.registerFactory<TransactionsNotifier>(() => TransactionsNotifier(transactionFind: getIt.get<ITransactionFind>(), transactionDelete: getIt.get<ITransactionDelete>(), accountFind: getIt.get<IAccountFind>()));
    getIt.registerFactory<TransferNotifier>(() => TransferNotifier(transferSave: getIt.get<ITransferSave>(), transferDelete: getIt.get<ITransferDelete>()));
  }

  Future<void> dispose() async {
    await GetIt.I.reset();

    (await DatabaseLocal.getInstance()).dispose();

    _instance = null;
  }
}

abstract class DI {
  static T get<T extends Object>() => GetIt.I.get<T>();
}
