import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('pt')];

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountBalance.
  ///
  /// In en, this message translates to:
  /// **'Account balance'**
  String get accountBalance;

  /// No description provided for @accountsBalance.
  ///
  /// In en, this message translates to:
  /// **'Account balances'**
  String get accountsBalance;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get accountDetails;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found.'**
  String get accountNotFound;

  /// No description provided for @accountUsedCreditCard.
  ///
  /// In en, this message translates to:
  /// **'This account is being used by a credit card.'**
  String get accountUsedCreditCard;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @addCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Add credit card'**
  String get addCreditCard;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Amount outstanding'**
  String get amountOutstanding;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @availableLimit.
  ///
  /// In en, this message translates to:
  /// **'Available limit'**
  String get availableLimit;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @backupButton.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupButton;

  /// No description provided for @backupButtonFinalized.
  ///
  /// In en, this message translates to:
  /// **'Finalized'**
  String get backupButtonFinalized;

  /// No description provided for @backupSubtitleExplication.
  ///
  /// In en, this message translates to:
  /// **'Making backups is essential to keep your data protected against unexpected events.'**
  String get backupSubtitleExplication;

  /// No description provided for @backupTitleExplication.
  ///
  /// In en, this message translates to:
  /// **'Preserve your important information!'**
  String get backupTitleExplication;

  /// No description provided for @balanceReadjustment.
  ///
  /// In en, this message translates to:
  /// **'Balance readjustment'**
  String get balanceReadjustment;

  /// No description provided for @bill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get bill;

  /// No description provided for @billAlreadyPaid.
  ///
  /// In en, this message translates to:
  /// **'Bill already paid.'**
  String get billAlreadyPaid;

  /// No description provided for @billClosedInDateTransaction.
  ///
  /// In en, this message translates to:
  /// **'The bill is already closed on this transaction date.'**
  String get billClosedInDateTransaction;

  /// No description provided for @billClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get billClosed;

  /// No description provided for @billGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Bill amount needs to be greater than zero.'**
  String get billGreaterThanZero;

  /// No description provided for @billNoMovements.
  ///
  /// In en, this message translates to:
  /// **'No movements'**
  String get billNoMovements;

  /// No description provided for @billOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get billOutstanding;

  /// No description provided for @billOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get billOverdue;

  /// No description provided for @billPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billPaid;

  /// No description provided for @billPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment bill'**
  String get billPayment;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cardExpense.
  ///
  /// In en, this message translates to:
  /// **'Card expense'**
  String get cardExpense;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get creditCard;

  /// No description provided for @creditCards.
  ///
  /// In en, this message translates to:
  /// **'Credit cards'**
  String get creditCards;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryCashback.
  ///
  /// In en, this message translates to:
  /// **'Cashback'**
  String get categoryCashback;

  /// No description provided for @categoryClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get categoryClothing;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryLeisure.
  ///
  /// In en, this message translates to:
  /// **'Leisure'**
  String get categoryLeisure;

  /// No description provided for @categoryEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get categoryEvents;

  /// No description provided for @categoryFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get categoryFuel;

  /// No description provided for @categoryGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryGifts;

  /// No description provided for @categoryMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get categoryMarket;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get categoryHome;

  /// No description provided for @categoryInvestments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get categoryInvestments;

  /// No description provided for @categoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Category not found.'**
  String get categoryNotFound;

  /// No description provided for @categoryOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get categoryOthers;

  /// No description provided for @categoryReadjustment.
  ///
  /// In en, this message translates to:
  /// **'Readjustment'**
  String get categoryReadjustment;

  /// No description provided for @categoryRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get categoryRestaurant;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get categoryServices;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @changeInitialAmount.
  ///
  /// In en, this message translates to:
  /// **'Change initial amount'**
  String get changeInitialAmount;

  /// No description provided for @changeInitialAmountExplication.
  ///
  /// In en, this message translates to:
  /// **'Your initial balance will be changed, and your current balance will be adjusted, resulting in possible variations in balances at the end of the month.'**
  String get changeInitialAmountExplication;

  /// No description provided for @changeInitialAmountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Readjust initial account balance?'**
  String get changeInitialAmountConfirmation;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @closingDay.
  ///
  /// In en, this message translates to:
  /// **'Closing day'**
  String get closingDay;

  /// No description provided for @closureDate.
  ///
  /// In en, this message translates to:
  /// **'Closure date'**
  String get closureDate;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete registration'**
  String get completeRegistration;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirm email'**
  String get confirmEmail;

  /// No description provided for @confirmEmailExplication.
  ///
  /// In en, this message translates to:
  /// **'We have sent a confirmation to your email address.\nLocate it in your inbox and follow the procedure.'**
  String get confirmEmailExplication;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Create account with Google'**
  String get createAccountWithGoogle;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get createCategory;

  /// No description provided for @createCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Create credit card'**
  String get createCreditCard;

  /// No description provided for @createTransaction.
  ///
  /// In en, this message translates to:
  /// **'Create transaction'**
  String get createTransaction;

  /// No description provided for @createTransactionExplication.
  ///
  /// In en, this message translates to:
  /// **'A transaction will be created to adjust the current balance.'**
  String get createTransactionExplication;

  /// No description provided for @createTransactionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Create adjustment transaction?'**
  String get createTransactionConfirmation;

  /// No description provided for @creditCardNotFound.
  ///
  /// In en, this message translates to:
  /// **'Credit card not found.'**
  String get creditCardNotFound;

  /// No description provided for @creditCardBillNotFound.
  ///
  /// In en, this message translates to:
  /// **'Credit card bill not found.'**
  String get creditCardBillNotFound;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete data'**
  String get deleteData;

  /// No description provided for @deleteDataExplication.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your data from the system.'**
  String get deleteDataExplication;

  /// No description provided for @deletingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Deleting transactions...'**
  String get deletingTransactions;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @doNotHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get doNotHaveAccount;

  /// No description provided for @dueDay.
  ///
  /// In en, this message translates to:
  /// **'Due day'**
  String get dueDay;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email.'**
  String get emailInvalid;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use.'**
  String get emailInUse;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified.'**
  String get emailNotVerified;

  /// No description provided for @errorStartDateAfterEndDate.
  ///
  /// In en, this message translates to:
  /// **'The start date cannot be after the end date.'**
  String get errorStartDateAfterEndDate;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @failedToAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Failed to authenticate.'**
  String get failedToAuthenticate;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @financialInstitution.
  ///
  /// In en, this message translates to:
  /// **'Financial institution'**
  String get financialInstitution;

  /// No description provided for @financialInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Financial institutions'**
  String get financialInstitutions;

  /// No description provided for @firstSteps.
  ///
  /// In en, this message translates to:
  /// **'First steps'**
  String get firstSteps;

  /// No description provided for @firstStepsExplication.
  ///
  /// In en, this message translates to:
  /// **'Configure Finan Master your way'**
  String get firstStepsExplication;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @greaterThan.
  ///
  /// In en, this message translates to:
  /// **'The value must be greater than'**
  String get greaterThan;

  /// No description provided for @greaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'The value must be greater than zero.'**
  String get greaterThanZero;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @incomes.
  ///
  /// In en, this message translates to:
  /// **'Incomes'**
  String get incomes;

  /// No description provided for @includeTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Include total balance'**
  String get includeTotalBalance;

  /// No description provided for @includeTotalBalanceExplication.
  ///
  /// In en, this message translates to:
  /// **'The balance of this account will be taken into consideration in the calculation of the total displayed balance.'**
  String get includeTotalBalanceExplication;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get incorrectPassword;

  /// No description provided for @initialAccountBalance.
  ///
  /// In en, this message translates to:
  /// **'Initial account balance'**
  String get initialAccountBalance;

  /// No description provided for @initialAmount.
  ///
  /// In en, this message translates to:
  /// **'Initial amount'**
  String get initialAmount;

  /// No description provided for @introduction1Title.
  ///
  /// In en, this message translates to:
  /// **'Manage your finances in one place'**
  String get introduction1Title;

  /// No description provided for @introduction1subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your expenses and income, and have an overview of your finances.'**
  String get introduction1subtitle;

  /// No description provided for @introduction2Title.
  ///
  /// In en, this message translates to:
  /// **'Simplify your transactions'**
  String get introduction2Title;

  /// No description provided for @introduction2subtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize your expenses and income efficiently, eliminating paperwork and streamlining your financial life.'**
  String get introduction2subtitle;

  /// No description provided for @introduction3Title.
  ///
  /// In en, this message translates to:
  /// **'Balance your finances for success'**
  String get introduction3Title;

  /// No description provided for @introduction3subtitle.
  ///
  /// In en, this message translates to:
  /// **'Master financial organization and unleash your power to reach new levels of stability and personal fulfillment.'**
  String get introduction3subtitle;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid value.'**
  String get invalidValue;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @lastBackupDate.
  ///
  /// In en, this message translates to:
  /// **'Last backup date'**
  String get lastBackupDate;

  /// No description provided for @lastSixMonths.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get lastSixMonths;

  /// No description provided for @lessThan.
  ///
  /// In en, this message translates to:
  /// **'The value must be less than'**
  String get lessThan;

  /// No description provided for @lessThanZero.
  ///
  /// In en, this message translates to:
  /// **'The value must be less than zero.'**
  String get lessThanZero;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginButtonName.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButtonName;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get moreDetails;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @monthlyBalanceCumulative.
  ///
  /// In en, this message translates to:
  /// **'Monthly balance cumulative'**
  String get monthlyBalanceCumulative;

  /// No description provided for @monthlyBalance.
  ///
  /// In en, this message translates to:
  /// **'Monthly balance'**
  String get monthlyBalance;

  /// No description provided for @monthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Monthly expense'**
  String get monthlyExpense;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get monthlyIncome;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get newAccount;

  /// No description provided for @newCreditCard.
  ///
  /// In en, this message translates to:
  /// **'New credit card'**
  String get newCreditCard;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noAccountsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No accounts registered.'**
  String get noAccountsRegistered;

  /// No description provided for @noCategoryRegistered.
  ///
  /// In en, this message translates to:
  /// **'No category registered.'**
  String get noCategoryRegistered;

  /// No description provided for @noCreditCardRegistered.
  ///
  /// In en, this message translates to:
  /// **'No credit card registered.'**
  String get noCreditCardRegistered;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet connection.'**
  String get noInternetConnection;

  /// No description provided for @noMovementsToPay.
  ///
  /// In en, this message translates to:
  /// **'No movements to pay.'**
  String get noMovementsToPay;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found.'**
  String get noRecordsFound;

  /// No description provided for @notDisplayAgain.
  ///
  /// In en, this message translates to:
  /// **'Do not display again'**
  String get notDisplayAgain;

  /// No description provided for @notPossibleShare.
  ///
  /// In en, this message translates to:
  /// **'It was not possible to share.'**
  String get notPossibleShare;

  /// No description provided for @notPossibleEditTransactionCreditCardPaid.
  ///
  /// In en, this message translates to:
  /// **'It is not possible to edit a credit card transaction that is already paid.'**
  String get notPossibleEditTransactionCreditCardPaid;

  /// No description provided for @notPossibleEditTransactionBillClosed.
  ///
  /// In en, this message translates to:
  /// **'It\'s not possible to edit a transaction on a closed bill.'**
  String get notPossibleEditTransactionBillClosed;

  /// No description provided for @notPossibleDeleteTransactionCreditCardPaid.
  ///
  /// In en, this message translates to:
  /// **'It\'s not possible to delete a credit card transaction that is already paid.'**
  String get notPossibleDeleteTransactionCreditCardPaid;

  /// No description provided for @notPossibleDeleteTransactionBillClosed.
  ///
  /// In en, this message translates to:
  /// **'It\'s not possible to delete a transaction on a closed bill.'**
  String get notPossibleDeleteTransactionBillClosed;

  /// No description provided for @noTransactionsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No transactions registered.'**
  String get noTransactionsRegistered;

  /// No description provided for @notPossibleToPayBill.
  ///
  /// In en, this message translates to:
  /// **'It is not possible to pay the bill.'**
  String get notPossibleToPayBill;

  /// No description provided for @nSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} selected}}'**
  String nSelected(num count);

  /// No description provided for @observation.
  ///
  /// In en, this message translates to:
  /// **'Observation'**
  String get observation;

  /// No description provided for @oneMonth.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get oneMonth;

  /// No description provided for @oneYear.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get oneYear;

  /// No description provided for @openBillAmount.
  ///
  /// In en, this message translates to:
  /// **'Open bill amount'**
  String get openBillAmount;

  /// No description provided for @operationCanceled.
  ///
  /// In en, this message translates to:
  /// **'Operation canceled.'**
  String get operationCanceled;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get passwordsNotMatch;

  /// No description provided for @payable.
  ///
  /// In en, this message translates to:
  /// **'Payable'**
  String get payable;

  /// No description provided for @paymentExceedBillAmount.
  ///
  /// In en, this message translates to:
  /// **'The payment cannot exceed the bill amount.'**
  String get paymentExceedBillAmount;

  /// No description provided for @paymentRequirementWhenClosedBill.
  ///
  /// In en, this message translates to:
  /// **'The full bill amount must be paid when it is closed.'**
  String get paymentRequirementWhenClosedBill;

  /// No description provided for @payBill.
  ///
  /// In en, this message translates to:
  /// **'Pay the bill'**
  String get payBill;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @prepay.
  ///
  /// In en, this message translates to:
  /// **'Prepay'**
  String get prepay;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @readjustBalance.
  ///
  /// In en, this message translates to:
  /// **'Readjust balance'**
  String get readjustBalance;

  /// No description provided for @readjustmentTransaction.
  ///
  /// In en, this message translates to:
  /// **'Readjustment transaction'**
  String get readjustmentTransaction;

  /// No description provided for @receivable.
  ///
  /// In en, this message translates to:
  /// **'Receivable'**
  String get receivable;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recentTransactions;

  /// No description provided for @registeredData.
  ///
  /// In en, this message translates to:
  /// **'Data already registered.'**
  String get registeredData;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmail;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your data on the system'**
  String get resetDataTitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordExplication.
  ///
  /// In en, this message translates to:
  /// **'An email with instructions to reset your password will be sent.'**
  String get resetPasswordExplication;

  /// No description provided for @resetPasswordNotification.
  ///
  /// In en, this message translates to:
  /// **'Password reset sent to your email.'**
  String get resetPasswordNotification;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackup;

  /// No description provided for @restoreBackupExplication.
  ///
  /// In en, this message translates to:
  /// **'Restore a backup to replace your current data with the backup data.'**
  String get restoreBackupExplication;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field.'**
  String get requiredField;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 second} other{{count} seconds}}'**
  String seconds(num count);

  /// No description provided for @see.
  ///
  /// In en, this message translates to:
  /// **'See'**
  String get see;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccount;

  /// No description provided for @selectBrand.
  ///
  /// In en, this message translates to:
  /// **'Select brand'**
  String get selectBrand;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @selectCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Select credit card'**
  String get selectCreditCard;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectFileInvalid.
  ///
  /// In en, this message translates to:
  /// **'The selected file is invalid.'**
  String get selectFileInvalid;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select icon'**
  String get selectIcon;

  /// No description provided for @selectFinancialInstitution.
  ///
  /// In en, this message translates to:
  /// **'Select financial institution'**
  String get selectFinancialInstitution;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sevenDays.
  ///
  /// In en, this message translates to:
  /// **'7D'**
  String get sevenDays;

  /// No description provided for @shortPassword.
  ///
  /// In en, this message translates to:
  /// **'The password must be at least eight characters long.'**
  String get shortPassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @sixMonth.
  ///
  /// In en, this message translates to:
  /// **'6M'**
  String get sixMonth;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @stepAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your first bank account'**
  String get stepAccount;

  /// No description provided for @stepCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Set up a credit card'**
  String get stepCreditCard;

  /// No description provided for @stepExpense.
  ///
  /// In en, this message translates to:
  /// **'Register your first expense'**
  String get stepExpense;

  /// No description provided for @stepIncome.
  ///
  /// In en, this message translates to:
  /// **'Register your first income'**
  String get stepIncome;

  /// No description provided for @sourceAccountAndDestinationEquals.
  ///
  /// In en, this message translates to:
  /// **'The source account and the destination account must be different.'**
  String get sourceAccountAndDestinationEquals;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @threeMonth.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get threeMonth;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @totalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total payable'**
  String get totalPayable;

  /// No description provided for @totalReceivable.
  ///
  /// In en, this message translates to:
  /// **'Total receivable'**
  String get totalReceivable;

  /// No description provided for @totalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total received'**
  String get totalReceived;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get totalSpent;

  /// No description provided for @transactionAmountExceedLimitBill.
  ///
  /// In en, this message translates to:
  /// **'The transaction amount cannot exceed the available credit limit on the bill.'**
  String get transactionAmountExceedLimitBill;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transactionDescription.
  ///
  /// In en, this message translates to:
  /// **'Transaction description'**
  String get transactionDescription;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found.'**
  String get transactionNotFound;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @transferAmountDivergent.
  ///
  /// In en, this message translates to:
  /// **'Outgoing and incoming account values are divergent.'**
  String get transferAmountDivergent;

  /// No description provided for @typeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category type'**
  String get typeCategory;

  /// No description provided for @uninformedAccount.
  ///
  /// In en, this message translates to:
  /// **'Uninformed account.'**
  String get uninformedAccount;

  /// No description provided for @uninformedCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Uninformed credit card.'**
  String get uninformedCreditCard;

  /// No description provided for @uninformedCardBrand.
  ///
  /// In en, this message translates to:
  /// **'Uninformed card brand.'**
  String get uninformedCardBrand;

  /// No description provided for @uninformedCategory.
  ///
  /// In en, this message translates to:
  /// **'Uninformed category.'**
  String get uninformedCategory;

  /// No description provided for @uninformedColor.
  ///
  /// In en, this message translates to:
  /// **'Uninformed color.'**
  String get uninformedColor;

  /// No description provided for @uninformedDescription.
  ///
  /// In en, this message translates to:
  /// **'Uninformed description.'**
  String get uninformedDescription;

  /// No description provided for @uninformedEmail.
  ///
  /// In en, this message translates to:
  /// **'Uninformed email.'**
  String get uninformedEmail;

  /// No description provided for @uninformedFinancialInstitution.
  ///
  /// In en, this message translates to:
  /// **'Uninformed financial institution.'**
  String get uninformedFinancialInstitution;

  /// No description provided for @uninformedIcon.
  ///
  /// In en, this message translates to:
  /// **'Uninformed icon.'**
  String get uninformedIcon;

  /// No description provided for @uninformedName.
  ///
  /// In en, this message translates to:
  /// **'Uninformed name.'**
  String get uninformedName;

  /// No description provided for @uninformedPassword.
  ///
  /// In en, this message translates to:
  /// **'Uninformed password.'**
  String get uninformedPassword;

  /// No description provided for @uninformedTypeCategory.
  ///
  /// In en, this message translates to:
  /// **'Type of category not informed.'**
  String get uninformedTypeCategory;

  /// No description provided for @unopened.
  ///
  /// In en, this message translates to:
  /// **'Unopened'**
  String get unopened;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @unReceived.
  ///
  /// In en, this message translates to:
  /// **'Unreceived'**
  String get unReceived;

  /// No description provided for @unrealized.
  ///
  /// In en, this message translates to:
  /// **'Unrealized'**
  String get unrealized;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found.'**
  String get userNotFound;

  /// No description provided for @unsharedBackup.
  ///
  /// In en, this message translates to:
  /// **'Unshared backup.'**
  String get unsharedBackup;

  /// No description provided for @utilized.
  ///
  /// In en, this message translates to:
  /// **'Utilized'**
  String get utilized;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
