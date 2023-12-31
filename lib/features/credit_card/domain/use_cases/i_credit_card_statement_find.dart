import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';

abstract interface class ICreditCardStatementFind {
  Future<CreditCardStatementEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard});
}
