import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/statement_status_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_find.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_statement_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardStatementNotifier extends ValueNotifier<CreditCardStatementState> {
  final ICreditCardStatementFind _creditCardStatementFind;

  CreditCardStatementNotifier({required ICreditCardStatementFind creditCardStatementFind})
      : _creditCardStatementFind = creditCardStatementFind,
        super(CreditCardStatementState.start());

  CreditCardStatementEntity? get creditCardStatement => value.creditCardStatement;

  StatementStatusEnum get status {
    final dateTimeNow = DateTime.now();
    if (creditCardStatement == null || (creditCardStatement?.totalPaid == 0 && creditCardStatement?.totalSpent == 0)) return StatementStatusEnum.noMovements;
    if ((dateTimeNow == creditCardStatement!.statementClosingDate || dateTimeNow.isAfter(creditCardStatement!.statementClosingDate)) && (dateTimeNow == creditCardStatement!.statementDueDate || dateTimeNow.isBefore(creditCardStatement!.statementDueDate))) return StatementStatusEnum.closed;
    if (dateTimeNow.isAfter(creditCardStatement!.statementDueDate)) return StatementStatusEnum.overdue;
    return StatementStatusEnum.outstanding;
  }

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
