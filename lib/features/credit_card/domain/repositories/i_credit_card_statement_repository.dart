import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';

abstract interface class ICreditCardStatementRepository {
  Future<CreditCardStatementEntity> save(CreditCardStatementEntity entity);

  Future<void> saveMany(List<CreditCardStatementEntity> statements);

  Future<CreditCardStatementEntity?> findById(String id);

  Future<CreditCardStatementEntity?> findFirstAfterDate({required DateTime date, required String idCreditCard});

  Future<List<CreditCardStatementEntity>> findAllAfterDate({required DateTime date, required String idCreditCard});
}
