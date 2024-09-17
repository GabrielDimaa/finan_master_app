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
}
