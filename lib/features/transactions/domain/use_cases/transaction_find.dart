import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transactions_by_period_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class TransactionFind implements ITransactionFind {
  final IExpenseRepository _expenseRepository;
  final IIncomeRepository _incomeRepository;
  final ITransferRepository _transferRepository;

  TransactionFind({
    required IExpenseRepository expenseRepository,
    required IIncomeRepository incomeRepository,
    required ITransferRepository transferRepository,
  })  : _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository,
        _transferRepository = transferRepository;

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
}
