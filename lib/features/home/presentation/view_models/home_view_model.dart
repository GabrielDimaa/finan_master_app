import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_find.dart';
import 'package:finan_master_app/features/config/domain/use_cases/i_config_save.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_with_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/features/home/domain/entities/home_monthly_balance_entity.dart';
import 'package:finan_master_app/features/home/domain/use_cases/i_home_monthly_balance.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

typedef ResultMonthlyTransaction = ({double amountsIncome, double amountsExpense});
typedef ResultTransactionsUnpaidUnreceived = ({double amountsIncome, double amountsExpense});

class HomeViewModel extends ChangeNotifier {
  final IAccountFind _accountFind;
  final ICreditCardFind _creditCardFind;
  final ITransactionFind _transactionFind;
  final IHomeMonthlyBalance _monthlyBalance;
  final IConfigFind _configFind;
  final IConfigSave _configSave;

  late final Command0<double> loadAccountsBalance;
  late final Command0<List<CreditCardWithBillEntity>> loadBillsCreditCard;
  late final Command0<List<HomeMonthlyBalanceEntity>> loadMonthlyBalance;
  late final Command0<ResultMonthlyTransaction> loadMonthlyTransaction;
  late final Command0<ResultTransactionsUnpaidUnreceived> loadTransactionsUnpaidUnreceived;

  HomeViewModel({
    required IAccountFind accountFind,
    required ICreditCardFind creditCardFind,
    required ITransactionFind transactionFind,
    required IHomeMonthlyBalance monthlyBalance,
    required IConfigFind configFind,
    required IConfigSave configSave,
  })  : _accountFind = accountFind,
        _creditCardFind = creditCardFind,
        _transactionFind = transactionFind,
        _monthlyBalance = monthlyBalance,
        _configFind = configFind,
        _configSave = configSave {
    loadAccountsBalance = Command0(_accountFind.findAccountsBalance);
    loadBillsCreditCard = Command0(_creditCardFind.findCreditCardsWithBill);
    loadMonthlyBalance = Command0(_loadMonthlyBalance);
    loadMonthlyTransaction = Command0(_loadMonthlyTransaction);
    loadTransactionsUnpaidUnreceived = Command0(_loadTransactionsUnpaidUnreceived);
  }

  bool _hideAmounts = false;

  bool get hideAmounts => _hideAmounts;

  void toggleHideAmounts() {
    _configSave.saveHideAmounts(!_hideAmounts);
    _hideAmounts = !_hideAmounts;

    notifyListeners();
  }

  Future<void> initialize() async {
    _hideAmounts = _configFind.findHideAmounts();

    await load();
  }

  Future<void> load() async {
    await Future.wait([
      loadAccountsBalance.execute(),
      loadBillsCreditCard.execute(),
      loadMonthlyBalance.execute(),
      loadMonthlyTransaction.execute(),
      loadTransactionsUnpaidUnreceived.execute(),
    ]);
  }

  Future<List<HomeMonthlyBalanceEntity>> _loadMonthlyBalance() async {
    final DateTime now = DateTime.now();
    final DateTime startMonth = now.subtractMonths(5).getInitialMonth();
    final DateTime endMonth = now.getFinalMonth();

    final List<HomeMonthlyBalanceEntity> results = await _monthlyBalance.findMonthlyBalances(startDate: startMonth, endDate: endMonth);

    List<HomeMonthlyBalanceEntity> monthlyBalances = [];

    for (int i = 0; i < 6; i++) {
      final DateTime date = i == 0 ? now : now.subtractMonths(i);

      monthlyBalances.add(
        results.firstWhere(
          (e) => e.date.year == date.year && e.date.month == date.month,
          orElse: () => HomeMonthlyBalanceEntity(date: date.getInitialMonth(), balance: 0),
        ),
      );
    }

    return monthlyBalances.reversed.toList();
  }

  Future<ResultMonthlyTransaction> _loadMonthlyTransaction() async {
    final DateTime dateNow = DateTime.now();
    final TransactionsByPeriodEntity transactions = await _transactionFind.findByPeriod(dateNow.getInitialMonth(), dateNow.getFinalMonth());

    return (amountsIncome: transactions.amountsIncome, amountsExpense: transactions.amountsExpense);
  }

  Future<ResultTransactionsUnpaidUnreceived> _loadTransactionsUnpaidUnreceived() async {
    final List<ITransactionEntity> transactions = await _transactionFind.findUnpaidUnreceived();

    return (
      amountsIncome: transactions.map((transaction) => transaction is IncomeEntity && !transaction.received ? transaction.amount : 0).sum.toDouble(),
      amountsExpense: transactions.map((transaction) => transaction is ExpenseEntity && !transaction.paid ? transaction.amount : 0).sum.toDouble(),
    );
  }
}
