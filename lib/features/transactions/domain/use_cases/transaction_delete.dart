import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_income_repository.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transfer_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_delete.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';

class TransactionDelete implements ITransactionDelete {
  final IIncomeRepository _incomeRepository;
  final IExpenseRepository _expenseRepository;
  final ITransferRepository _transferRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  TransactionDelete({
    required IIncomeRepository incomeRepository,
    required IExpenseRepository expenseRepository,
    required ITransferRepository transferRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _incomeRepository = incomeRepository,
        _expenseRepository = expenseRepository,
        _transferRepository = transferRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<void> deleteTransactions(List<ITransactionEntity> transactions) async {
    await _localDBTransactionRepository.openTransaction((txn) async {
      List<Future<dynamic> Function()> functions = [];

      for (final transaction in transactions) {
        functions.add(
          switch (transaction) {
            IncomeEntity _ => () async => _incomeRepository.delete(transaction, txn: txn),
            ExpenseEntity _ => () async => _expenseRepository.delete(transaction, txn: txn),
            TransferEntity _ => () async => _transferRepository.delete(transaction, txn: txn),
            _ => () async {},
          },
        );
      }

      await Future.wait([...functions.map((f) => f()).toList()]);
    });
  }
}
