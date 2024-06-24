import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';

sealed class CreditCardStatementsState {
  final List<CreditCardStatementEntity> statements;

  const CreditCardStatementsState({required this.statements});

  factory CreditCardStatementsState.start() => const StartCreditCardStatementsState();

  CreditCardStatementsState setStatements(List<CreditCardStatementEntity> statements) => ListCreditCardStatementsState(statements: statements);

  CreditCardStatementsState setLoading() => LoadingCreditCardStatementsState(statements: statements);

  CreditCardStatementsState setError(String message) => ErrorCreditCardStatementsState(message, statements: statements);
}

class StartCreditCardStatementsState extends CreditCardStatementsState {
  const StartCreditCardStatementsState() : super(statements: const []);
}

class LoadingCreditCardStatementsState extends CreditCardStatementsState {
  const LoadingCreditCardStatementsState({required super.statements});
}

class ListCreditCardStatementsState extends CreditCardStatementsState {
  const ListCreditCardStatementsState({required super.statements});
}

class ErrorCreditCardStatementsState extends CreditCardStatementsState {
  final String message;

  const ErrorCreditCardStatementsState(this.message, {required super.statements});
}
