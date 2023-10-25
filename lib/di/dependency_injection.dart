import 'package:finan_master_app/features/account/domain/repositories/i_account_repository.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_find.dart';
import 'package:finan_master_app/features/account/domain/use_cases/account_save.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_delete.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_save.dart';
import 'package:finan_master_app/features/account/infra/data_sources/account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/data_sources/i_account_local_data_source.dart';
import 'package:finan_master_app/features/account/infra/repositories/account_repository.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/account_notifier.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/backup/domain/repositories/i_backup_repository.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/backup.dart';
import 'package:finan_master_app/features/backup/domain/use_cases/i_backup.dart';
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
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_statement_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_statement_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_dates.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/credit_card_statement_dates.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/repositories/credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/infra/repositories/credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/infra/repositories/credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_expense_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_card_statement_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_cards_notifier.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/income_save.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/transaction_find.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/transfer_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/transfer_save.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_expense_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/income_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/transaction_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/transfer_local_data_source.dart';
import 'package:finan_master_app/features/transactions/infra/repositories/expense_repository.dart';
import 'package:finan_master_app/features/transactions/infra/repositories/income_repository.dart';
import 'package:finan_master_app/features/transactions/infra/repositories/transaction_repository.dart';
import 'package:finan_master_app/features/transactions/infra/repositories/transfer_repository.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/expense_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/income_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transactions_notifier.dart';
import 'package:finan_master_app/features/transactions/presentation/notifiers/transfer_notifier.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/database_local.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local.dart';
import 'package:finan_master_app/shared/infra/drivers/share/i_share_driver.dart';
import 'package:finan_master_app/shared/infra/drivers/share/share_driver.dart';
import 'package:finan_master_app/shared/infra/repositories/local_db_transaction_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._();

  DependencyInjection._();

  factory DependencyInjection() => _instance;

  Future<void> setup() async {
    final GetIt getIt = GetIt.instance;

    //Drivers
    getIt.registerFactory<IShareDriver>(() => ShareDriver());

    //Data Sources
    final DatabaseLocal databaseLocal = await DatabaseLocal.getInstance();
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    getIt.registerSingleton<IDatabaseLocal>(databaseLocal);
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerFactory<ICacheLocal>(() => CacheLocal(sharedPreferences: sharedPreferences));

    getIt.registerFactory<IAccountLocalDataSource>(() => AccountLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ICategoryLocalDataSource>(() => CategoryLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ICreditCardLocalDataSource>(() => CreditCardLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ICreditCardTransactionLocalDataSource>(() => CreditCardTransactionLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ICreditCardStatementLocalDataSource>(() => CreditCardStatementLocalDataSource(databaseLocal: databaseLocal, creditCardTransactionLocalDataSource: getIt.get<ICreditCardTransactionLocalDataSource>()));
    getIt.registerFactory<IExpenseLocalDataSource>(() => ExpenseLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: getIt.get<ITransactionLocalDataSource>()));
    getIt.registerFactory<IIncomeLocalDataSource>(() => IncomeLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: getIt.get<ITransactionLocalDataSource>()));
    getIt.registerFactory<ITransactionLocalDataSource>(() => TransactionLocalDataSource(databaseLocal: databaseLocal));
    getIt.registerFactory<ITransferLocalDataSource>(() => TransferLocalDataSource(databaseLocal: databaseLocal, transactionDataSource: getIt.get<ITransactionLocalDataSource>()));

    //Repositories
    getIt.registerFactory<IAccountRepository>(() => AccountRepository(dataSource: getIt.get<IAccountLocalDataSource>()));
    getIt.registerFactory<IBackupRepository>(() => BackupRepository(databaseLocal: databaseLocal, cacheLocal: getIt.get<ICacheLocal>(), shareDriver: getIt.get<IShareDriver>()));
    getIt.registerFactory<ICategoryRepository>(() => CategoryRepository(dataSource: getIt.get<ICategoryLocalDataSource>()));
    getIt.registerFactory<IConfigRepository>(() => ConfigRepository(cacheLocal: getIt.get<ICacheLocal>()));
    getIt.registerFactory<ICreditCardRepository>(() => CreditCardRepository(creditCardDataSource: getIt.get<ICreditCardLocalDataSource>()));
    getIt.registerFactory<ICreditCardStatementRepository>(() => CreditCardStatementRepository(localDataSource: getIt.get<ICreditCardStatementLocalDataSource>(), creditCardTransactionLocalDataSource: getIt.get<ICreditCardTransactionLocalDataSource>(), dbTransaction: databaseLocal.transactionInstance()));
    getIt.registerFactory<ICreditCardTransactionRepository>(() => CreditCardTransactionRepository(dataSource: getIt.get<ICreditCardTransactionLocalDataSource>(), dbTransaction: databaseLocal.transactionInstance()));
    getIt.registerFactory<IExpenseRepository>(() => ExpenseRepository(dbTransaction: databaseLocal.transactionInstance(), expenseLocalDataSource: getIt.get<IExpenseLocalDataSource>(), transactionLocalDataSource: getIt.get<ITransactionLocalDataSource>()));
    getIt.registerFactory<IIncomeRepository>(() => IncomeRepository(dbTransaction: databaseLocal.transactionInstance(), incomeLocalDataSource: getIt.get<IIncomeLocalDataSource>(), transactionLocalDataSource: getIt.get<ITransactionLocalDataSource>()));
    getIt.registerFactory<ILocalDBTransactionRepository>(() => LocalDBTransactionRepository(databaseLocalTransaction: databaseLocal.transactionInstance()));
    getIt.registerFactory<ITransactionRepository>(() => TransactionRepository(transactionDataSource: getIt.get<ITransactionLocalDataSource>()));
    getIt.registerFactory<ITransferRepository>(() => TransferRepository(dbTransaction: databaseLocal.transactionInstance(), transferLocalDataSource: getIt.get<ITransferLocalDataSource>(), transactionLocalDataSource: getIt.get<ITransactionLocalDataSource>()));

    //Use cases
    getIt.registerFactory<IAccountDelete>(() => AccountDelete(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAccountFind>(() => AccountFind(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IAccountSave>(() => AccountSave(repository: getIt.get<IAccountRepository>()));
    getIt.registerFactory<IBackup>(() => Backup(repository: getIt.get<IBackupRepository>()));
    getIt.registerFactory<ICategoryDelete>(() => CategoryDelete(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategoryFind>(() => CategoryFind(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<ICategorySave>(() => CategorySave(repository: getIt.get<ICategoryRepository>()));
    getIt.registerFactory<IConfigFind>(() => ConfigFind(repository: getIt.get<IConfigRepository>()));
    getIt.registerFactory<IConfigSave>(() => ConfigSave(repository: getIt.get<IConfigRepository>()));
    getIt.registerFactory<ICreditCardDelete>(() => CreditCardDelete(repository: getIt.get<ICreditCardRepository>()));
    getIt.registerFactory<ICreditCardFind>(() => CreditCardFind(repository: getIt.get<ICreditCardRepository>()));
    getIt.registerFactory<ICreditCardSave>(() => CreditCardSave(creditCardStatementDates: getIt.get<ICreditCardStatementDates>(), repository: getIt.get<ICreditCardRepository>(), creditCardStatementRepository: getIt.get<ICreditCardStatementRepository>(), creditCardTransactionRepository: getIt.get<ICreditCardTransactionRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<ICreditCardStatementFind>(() => CreditCardStatementFind(repository: getIt.get<ICreditCardStatementRepository>()));
    getIt.registerFactory<ICreditCardStatementSave>(() => CreditCardStatementSave(repository: getIt.get<ICreditCardStatementRepository>(), creditCardTransactionRepository: getIt.get<ICreditCardTransactionRepository>(), creditCardRepository: getIt.get<ICreditCardRepository>(), expenseRepository: getIt.get<IExpenseRepository>(), localDBTransactionRepository: getIt.get<ILocalDBTransactionRepository>()));
    getIt.registerFactory<ICreditCardTransactionDelete>(() => CreditCardTransactionDelete(repository: getIt.get<ICreditCardTransactionRepository>(), creditCardStatementRepository: getIt.get<ICreditCardStatementRepository>()));
    getIt.registerFactory<ICreditCardTransactionSave>(() => CreditCardTransactionSave(creditCardStatementDates: getIt.get<ICreditCardStatementDates>(), repository: getIt.get<ICreditCardRepository>(), creditCardStatementRepository: getIt.get<ICreditCardStatementRepository>(), creditCardTransactionRepository: getIt.get<ICreditCardTransactionRepository>()));
    getIt.registerFactory<IExpenseDelete>(() => ExpenseDelete(repository: getIt.get<IExpenseRepository>()));
    getIt.registerFactory<IExpenseSave>(() => ExpenseSave(repository: getIt.get<IExpenseRepository>()));
    getIt.registerFactory<IIncomeDelete>(() => IncomeDelete(repository: getIt.get<IIncomeRepository>()));
    getIt.registerFactory<IIncomeSave>(() => IncomeSave(repository: getIt.get<IIncomeRepository>()));
    getIt.registerFactory<ICreditCardStatementDates>(() => CreditCardStatementDates());
    getIt.registerFactory<ITransactionFind>(() => TransactionFind(repository: getIt.get<ITransactionRepository>()));
    getIt.registerFactory<ITransferDelete>(() => TransferDelete(repository: getIt.get<ITransferRepository>()));
    getIt.registerFactory<ITransferSave>(() => TransferSave(repository: getIt.get<ITransferRepository>()));

    //Notifiers
    getIt.registerFactory<AccountNotifier>(() => AccountNotifier(accountFind: getIt.get<IAccountFind>(), accountSave: getIt.get<IAccountSave>(), accountDelete: getIt.get<IAccountDelete>(), incomeSave: getIt.get<IIncomeSave>(), expenseSave: getIt.get<IExpenseSave>()));
    getIt.registerFactory<AccountsNotifier>(() => AccountsNotifier(accountFind: getIt.get<IAccountFind>()));
    getIt.registerFactory<BackupNotifier>(() => BackupNotifier(backup: getIt.get<IBackup>()));
    getIt.registerFactory<CategoriesNotifier>(() => CategoriesNotifier(categoryFind: getIt.get<ICategoryFind>()));
    getIt.registerFactory<CategoryNotifier>(() => CategoryNotifier(categorySave: getIt.get<ICategorySave>(), categoryDelete: getIt.get<ICategoryDelete>()));
    getIt.registerFactory<CreditCardNotifier>(() => CreditCardNotifier(creditCardSave: getIt.get<ICreditCardSave>(), creditCardDelete: getIt.get<ICreditCardDelete>()));
    getIt.registerFactory<CreditCardExpenseNotifier>(() => CreditCardExpenseNotifier(creditCardTransactionSave: getIt.get<ICreditCardTransactionSave>(), creditCardTransactionDelete: getIt.get<ICreditCardTransactionDelete>()));
    getIt.registerFactory<CreditCardsNotifier>(() => CreditCardsNotifier(creditCardFind: getIt.get<ICreditCardFind>()));
    getIt.registerFactory<CreditCardStatementNotifier>(() => CreditCardStatementNotifier(creditCardStatementFind: getIt.get<ICreditCardStatementFind>(), creditCardStatementSave: getIt.get<ICreditCardStatementSave>()));
    getIt.registerFactory<ExpenseNotifier>(() => ExpenseNotifier(expenseSave: getIt.get<IExpenseSave>(), expenseDelete: getIt.get<IExpenseDelete>()));
    getIt.registerFactory<IncomeNotifier>(() => IncomeNotifier(incomeSave: getIt.get<IIncomeSave>(), incomeDelete: getIt.get<IIncomeDelete>()));
    getIt.registerSingleton<LocaleNotifier>(LocaleNotifier(configFind: getIt.get<IConfigFind>(), configSave: getIt.get<IConfigSave>()));
    getIt.registerSingleton<ThemeModeNotifier>(ThemeModeNotifier(configFind: getIt.get<IConfigFind>(), configSave: getIt.get<IConfigSave>()));
    getIt.registerFactory<TransactionsNotifier>(() => TransactionsNotifier(transactionFind: getIt.get<ITransactionFind>(), accountFind: getIt.get<IAccountFind>()));
    getIt.registerFactory<TransferNotifier>(() => TransferNotifier(transferSave: getIt.get<ITransferSave>(), transferDelete: getIt.get<ITransferDelete>()));
  }
}
