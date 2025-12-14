import 'package:collection/collection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/domain/use_cases/i_account_find.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class TransactionsUnpaidUnreceivedViewModel extends ChangeNotifier {
  final ITransactionFind _transactionFind;
  final ITransactionDelete _transactionDelete;
  final ICategoryFind _categoryFind;
  final IAccountFind _accountFind;

  late final Command1<void, CategoryTypeEnum> init;

  TransactionsUnpaidUnreceivedViewModel({
    required ITransactionFind transactionFind,
    required ITransactionDelete transactionDelete,
    required ICategoryFind categoryFind,
    required IAccountFind accountFind,
  })  : _transactionFind = transactionFind,
        _transactionDelete = transactionDelete,
        _categoryFind = categoryFind,
        _accountFind = accountFind {
    init = Command1(_init);
  }

  List<ITransactionEntity> _transactions = [];

  List<ITransactionEntity> get transactions => _transactions;

  double get totalPaidOrReceived => transactions.map((e) => isPaidOrReceived(e) ? e.amount : 0.0).sum.toDouble();

  double get totalPayableOrReceivable => transactions.map((e) => isPaidOrReceived(e) ? 0.0 : e.amount).sum.toDouble();

  List<CategoryEntity> _categories = [];

  List<CategoryEntity> get categories => _categories;

  List<AccountEntity> _accounts = [];

  List<AccountEntity> get accounts => _accounts;

  Future<void> _init(CategoryTypeEnum type) async {
    await Future.wait([
      _transactionFind.findUnpaidUnreceived(type: type).then((value) => _transactions = value),
      _categoryFind.findAll(deleted: true).then((value) => _categories = value),
      _accountFind.findAll(deleted: true).then((value) => _accounts = value),
    ]);
  }

  Future<void> deleteTransactions(List<ITransactionEntity> value) async {
    await _transactionDelete.deleteTransactions(value);
    _transactions = transactions.where((e) => !value.any((t) => t.id == e.id)).toList();

    notifyListeners();
  }

  void setTransactions(List<ITransactionEntity> value) {
    _transactions = value;
    notifyListeners();
  }

  bool isPaidOrReceived(ITransactionEntity transaction) => transaction is ExpenseEntity ? transaction.paid : (transaction as IncomeEntity).received;
}
