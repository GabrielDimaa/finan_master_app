import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

abstract interface class ICreditCardBillRepository {
  Future<CreditCardBillEntity> save(CreditCardBillEntity entity);

  Future<void> saveMany(List<CreditCardBillEntity> bills, {ITransactionExecutor? txn});

  Future<CreditCardBillEntity> saveOnlyBill(CreditCardBillEntity entity, {ITransactionExecutor? txn});

  Future<CreditCardBillEntity?> findById(String id);

  Future<List<CreditCardBillEntity>> findByIds(List<String> ids);

  Future<CreditCardBillEntity?> findFirstAfterDate({required DateTime date, required String idCreditCard});

  Future<List<CreditCardBillEntity>> findAllAfterDate({required DateTime date, required String idCreditCard, ITransactionExecutor? txn});

  Future<CreditCardBillEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard});

  Future<List<CreditCardBillEntity>> findByPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard});
}
