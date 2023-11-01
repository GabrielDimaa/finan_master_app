import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_statement_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardStatementNotifier extends ValueNotifier<CreditCardStatementState> {
  final ICreditCardStatementFind _creditCardStatementFind;
  final ICreditCardStatementSave _creditCardStatementSave;
  final ICreditCardTransactionDelete _creditCardTransactionDelete;

  CreditCardStatementNotifier({
    required ICreditCardStatementFind creditCardStatementFind,
    required ICreditCardStatementSave creditCardStatementSave,
    required ICreditCardTransactionDelete creditCardTransactionDelete,
  })  : _creditCardStatementFind = creditCardStatementFind,
        _creditCardStatementSave = creditCardStatementSave,
        _creditCardTransactionDelete = creditCardTransactionDelete,
        super(CreditCardStatementState.start());

  CreditCardStatementEntity? get creditCardStatement => value.creditCardStatement;

  void setStatement(CreditCardStatementEntity? statement) => value = value.setStatement(statement);

  Future<void> findByPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard}) async {
    try {
      value = value.setFiltering();
      final CreditCardStatementEntity? statement = await _creditCardStatementFind.findFirstInPeriod(startDate: startDate, endDate: endDate, idCreditCard: idCreditCard);
      value = value.setStatement(statement);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> payStatement(double payValue) async {
    try {
      value = value.setSaving();
      final CreditCardStatementEntity statement = await _creditCardStatementSave.payStatement(creditCardStatement: creditCardStatement!, payValue: payValue);
      value = value.setStatement(statement);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> deleteTransactions(List<CreditCardTransactionEntity> transactions) => _creditCardTransactionDelete.deleteMany(transactions);
}
