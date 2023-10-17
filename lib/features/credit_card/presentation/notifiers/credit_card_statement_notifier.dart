import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_find.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_statement_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardStatementNotifier extends ValueNotifier<CreditCardStatementState> {
  final ICreditCardStatementFind _creditCardStatementFind;

  CreditCardStatementNotifier({required ICreditCardStatementFind creditCardStatementFind})
      : _creditCardStatementFind = creditCardStatementFind,
        super(CreditCardStatementState.start());

  Future<void> findByPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard}) async {
    try {
      value = value.setFiltering();
      final CreditCardStatementEntity? statement = await _creditCardStatementFind.findFirstInPeriod(startDate: startDate, endDate: endDate, idCreditCard: idCreditCard);
      value = value.setStatement(statement);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
