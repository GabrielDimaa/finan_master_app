import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';

abstract interface class ICreditCardStatementSave {
  Future<CreditCardStatementEntity> payStatement({required CreditCardStatementEntity creditCardStatement, required double payValue});
}
