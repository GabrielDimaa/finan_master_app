import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/statement/domain/repositories/i_statement_repository.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_expense_repository.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_expense_delete.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class ExpenseDelete implements IExpenseDelete {
  final IExpenseRepository _repository;
  final IStatementRepository _statementRepository;
  final ICreditCardTransactionRepository _creditCardTransactionRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;
  final IAdAccess _adAccess;

  ExpenseDelete({
    required IExpenseRepository repository,
    required IStatementRepository statementRepository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
    required IAdAccess adAccess,
  })  : _repository = repository,
        _statementRepository = statementRepository,
        _creditCardTransactionRepository = creditCardTransactionRepository,
        _localDBTransactionRepository = localDBTransactionRepository,
        _adAccess = adAccess;

  @override
  Future<void> delete(ExpenseEntity entity, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      return await _localDBTransactionRepository.openTransaction((newTxn) => delete(entity, txn: newTxn));
    }

    CreditCardTransactionEntity? creditCardTransaction;

    if (entity.idCreditCardTransaction != null) {
      creditCardTransaction = await _creditCardTransactionRepository.findById(entity.idCreditCardTransaction!, txn: txn);
    }

    await Future.wait([
      _repository.delete(entity, txn: txn),
      if (creditCardTransaction != null) _creditCardTransactionRepository.delete(creditCardTransaction, txn: txn),
      _statementRepository.deleteByIdExpense(entity.id, txn: txn),
    ]);

    _adAccess.consumeUse();
  }
}
