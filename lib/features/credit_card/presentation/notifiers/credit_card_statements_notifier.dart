import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_find.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_statements_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardStatementsNotifier extends ValueNotifier<CreditCardStatementsState> {
  final ICreditCardStatementFind _creditCardStatementFind;

  CreditCardStatementsNotifier({required ICreditCardStatementFind creditCardStatementFind})
      : _creditCardStatementFind = creditCardStatementFind,
        super(CreditCardStatementsState.start());

  void setStatements(List<CreditCardStatementEntity> statements) => value = value.setStatements(statements);

  Future<void> findAllAfterDate({required DateTime date, required String idCreditCard}) async {
    try {
      value = value.setLoading();
      final List<CreditCardStatementEntity> statements = await _creditCardStatementFind.findAllAfterDate(date: date, idCreditCard: idCreditCard);

      value = value.setStatements(statements);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }
}
