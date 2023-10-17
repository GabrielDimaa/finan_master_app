import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';

sealed class CreditCardStatementState {
  final CreditCardStatementEntity? creditCardStatement;

  const CreditCardStatementState({required this.creditCardStatement});

  factory CreditCardStatementState.start() => const StartCreditCardStatementState();

  CreditCardStatementState setStatement(CreditCardStatementEntity? statement) => ChangedCreditCardStatementState(creditCardStatement: statement);

  CreditCardStatementState changedStatement() => ChangedCreditCardStatementState(creditCardStatement: creditCardStatement);

  CreditCardStatementState setFiltering() => const FilteringCreditCardStatementState();

  CreditCardStatementState setSaving() => SavingCreditCardStatementState(creditCardStatement: creditCardStatement);

  CreditCardStatementState setError(String message) => ErrorCreditCardStatementState(message, creditCardStatement: creditCardStatement);
}

class StartCreditCardStatementState extends CreditCardStatementState {
  const StartCreditCardStatementState() : super(creditCardStatement: null);
}

class ChangedCreditCardStatementState extends CreditCardStatementState {
  const ChangedCreditCardStatementState({required super.creditCardStatement});
}

class FilteringCreditCardStatementState extends CreditCardStatementState {
  const FilteringCreditCardStatementState() : super(creditCardStatement: null);
}

class SavingCreditCardStatementState extends CreditCardStatementState {
  const SavingCreditCardStatementState({required super.creditCardStatement});
}

class ErrorCreditCardStatementState extends CreditCardStatementState {
  final String message;

  const ErrorCreditCardStatementState(this.message, {required super.creditCardStatement});
}
