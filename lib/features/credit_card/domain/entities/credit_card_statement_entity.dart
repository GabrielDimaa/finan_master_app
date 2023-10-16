import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardStatementEntity extends Entity {
  DateTime statementClosingDate;
  DateTime statementDueDate;

  final String idCreditCard;

  final double statementAmount;
  final double amountLimit;

  double get amountAvailable => amountLimit - statementAmount;

  CreditCardStatementEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.statementClosingDate,
    required this.statementDueDate,
    required this.idCreditCard,
    required this.statementAmount,
    required this.amountLimit,
  });
}
