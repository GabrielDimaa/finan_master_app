import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_income_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_delete.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transfer_delete.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';

class TransactionDelete implements ITransactionDelete {
  final IIncomeDelete _incomeDelete;
  final IExpenseDelete _expenseDelete;
  final ITransferDelete _transferDelete;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  TransactionDelete({
    required IIncomeDelete incomeDelete,
    required IExpenseDelete expenseDelete,
    required ITransferDelete transferDelete,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _incomeDelete = incomeDelete,
        _expenseDelete = expenseDelete,
        _transferDelete = transferDelete,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<void> deleteTransactions(List<ITransactionEntity> transactions) async {
    await _localDBTransactionRepository.openTransaction((txn) async {
      List<Future<dynamic> Function()> functions = [];

      for (final transaction in transactions) {
        functions.add(
          switch (transaction) {
            IncomeEntity _ => () async => _incomeDelete.delete(transaction, txn: txn),
            ExpenseEntity _ => () async => _expenseDelete.delete(transaction, txn: txn),
            TransferEntity _ => () async => _transferDelete.delete(transaction, txn: txn),
            _ => () async {},
          },
        );
      }

      await Future.wait([...functions.map((f) => f()).toList()]);
    });
  }
}
