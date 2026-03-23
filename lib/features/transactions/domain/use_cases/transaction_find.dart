import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_search_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class TransactionFind implements ITransactionFind {
  final IExpenseRepository _expenseRepository;
  final IIncomeRepository _incomeRepository;
  final ITransferRepository _transferRepository;
  final ITransactionRepository _transactionRepository;

  TransactionFind({
    required IExpenseRepository expenseRepository,
    required IIncomeRepository incomeRepository,
    required ITransferRepository transferRepository,
    required ITransactionRepository transactionRepository,
  })  : _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository,
        _transferRepository = transferRepository,
        _transactionRepository = transactionRepository;

  @override
  Future<TransactionsByPeriodEntity> findByPeriod(DateTime startDate, DateTime endDate) async {
    if (endDate.isBefore(startDate)) throw Exception(R.strings.errorStartDateAfterEndDate);

    final List<ITransactionEntity> transactions = <ITransactionEntity>[];

    await Future.wait([
      _expenseRepository.findByPeriod(startDate, endDate).then((value) => transactions.addAll(value)),
      _incomeRepository.findByPeriod(startDate, endDate).then((value) => transactions.addAll(value)),
      _transferRepository.findByPeriod(startDate, endDate).then((value) => transactions.addAll(value)),
    ]);

    transactions.sort((a, b) => b.date.compareTo(a.date));

    return TransactionsByPeriodEntity(transactions: transactions);
  }

  @override
  Future<List<ITransactionEntity>> findUnpaidUnreceived({CategoryTypeEnum? type}) async {
    final List<ITransactionEntity> transactions = <ITransactionEntity>[];

    await Future.wait([
      if (type == null || type == CategoryTypeEnum.expense) _expenseRepository.findUnpaid().then((value) => transactions.addAll(value)),
      if (type == null || type == CategoryTypeEnum.income) _incomeRepository.findUnreceived().then((value) => transactions.addAll(value)),
    ]);

    return transactions..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<List<TransactionSearchEntity>> search({required String text, required int limit, required int offset}) => _transactionRepository.search(text: text, limit: limit, offset: offset);
}
