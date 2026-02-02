import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

typedef InitParams = ({DateTime startDate, DateTime endDate, Set<CategoryTypeEnum?> filterType});
typedef FindByPeriodParams = ({DateTime startDate, DateTime endDate});

class TransactionsListViewModel extends ChangeNotifier {
  final ITransactionFind _transactionFind;
  final ICategoryFind _categoryFind;
  final IAccountFind _accountFind;

  late final Command1<void, InitParams> init;
  late final Command1<void, FindByPeriodParams> findByPeriod;
  late final Command1<void, List<ITransactionEntity>> deleteTransactions;

  TransactionsListViewModel({
    required ITransactionFind transactionFind,
    required ITransactionDelete transactionDelete,
    required ICategoryFind categoryFind,
    required IAccountFind accountFind,
  })  : _transactionFind = transactionFind,
        _categoryFind = categoryFind,
        _accountFind = accountFind {
    init = Command1(_init);
    findByPeriod = Command1(_findByPeriod);
    deleteTransactions = Command1(transactionDelete.deleteTransactions);
  }

  DateTime _startDate = DateTime.now().getInitialMonth();

  DateTime get startDate => _startDate;

  DateTime _endDate = DateTime.now().getFinalMonth();

  DateTime get endDate => _endDate;

  List<CategoryEntity> _categories = [];

  List<CategoryEntity> get categories => _categories;

  List<AccountEntity> _accounts = [];

  List<AccountEntity> get accounts => _accounts;

  Set<CategoryTypeEnum?> _filterType = {null};

  Set<CategoryTypeEnum?> get filterType => _filterType;

  TransactionsByPeriodEntity _transactionsByPeriod = TransactionsByPeriodEntity(transactions: []);

  TransactionsByPeriodEntity get transactionsByPeriod => _transactionsByPeriod;

  List<ITransactionEntity> get transactions {
    if (_filterType.firstOrNull == CategoryTypeEnum.expense) return _transactionsByPeriod.transactions.whereType<ExpenseEntity>().toList();
    if (_filterType.firstOrNull == CategoryTypeEnum.income) return _transactionsByPeriod.transactions.whereType<IncomeEntity>().toList();

    return _transactionsByPeriod.transactions;
  }

  double _monthlyBalanceCumulative = 0;

  double get monthlyBalanceCumulative => _monthlyBalanceCumulative;

  Future<void> _init(InitParams params) async {
    _filterType = params.filterType;
    _startDate = params.startDate;
    _endDate = params.endDate;

    await Future.wait([
      _categoryFind.findAll(deleted: true).then((value) => _categories = value),
      _accountFind.findAll(deleted: true).then((value) => _accounts = value),
      _findByPeriod((startDate: params.startDate, endDate: params.endDate)),
    ]);
  }

  Future<void> _findByPeriod(FindByPeriodParams params) async {
    _startDate = params.startDate;
    _endDate = params.endDate;

    _transactionsByPeriod = await _transactionFind.findByPeriod(startDate, endDate);
    _monthlyBalanceCumulative = await _accountFind.findBalanceUntilDate(endDate);
  }

  void setFilterType(Set<CategoryTypeEnum?> type) {
    _filterType = type;
    notifyListeners();
  }
}
