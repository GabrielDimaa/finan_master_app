import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardStatementModel extends Model {
  final DateTime statementClosingDate;
  final DateTime statementDueDate;

  final String idCreditCard;

  final double statementAmount;
  final double amountLimit;

  CreditCardStatementModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.statementClosingDate,
    required this.statementDueDate,
    required this.idCreditCard,
    required this.statementAmount,
    required this.amountLimit,
  });

  @override
  CreditCardStatementModel clone() {
    return CreditCardStatementModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      statementClosingDate: statementClosingDate,
      statementDueDate: statementDueDate,
      idCreditCard: idCreditCard,
      statementAmount: statementAmount,
      amountLimit: amountLimit,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'statement_closing_date': statementClosingDate.toIso8601String(),
      'statement_due_date': statementDueDate.toIso8601String(),
      'id_credit_card': idCreditCard,
    };
  }
}
