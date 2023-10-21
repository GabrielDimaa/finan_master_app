import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class ICreditCardStatementRepository {
  Future<CreditCardStatementEntity> save(CreditCardStatementEntity entity);

  Future<void> saveMany(List<CreditCardStatementEntity> statements, {ITransactionExecutor? txn});

  Future<CreditCardStatementEntity> saveOnlyStatement(CreditCardStatementEntity entity);

  Future<CreditCardStatementEntity?> findById(String id);

  Future<CreditCardStatementEntity?> findFirstAfterDate({required DateTime date, required String idCreditCard});

  Future<List<CreditCardStatementEntity>> findAllAfterDate({required DateTime date, required String idCreditCard, ITransactionExecutor? txn});

  Future<CreditCardStatementEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard});
}
