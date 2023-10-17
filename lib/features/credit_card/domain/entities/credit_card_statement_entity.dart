import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardStatementEntity extends Entity {
  DateTime statementClosingDate;
  DateTime statementDueDate;

  final String idCreditCard;

  final double totalPaid;
  final double totalSpent;
  final double amountLimit;

  //totalPaid terá valor negativo, portanto, 1000 + (-100).
  double get statementAmount => totalSpent + totalPaid;

  double get amountAvailable => amountLimit - statementAmount;

  CreditCardStatementEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.statementClosingDate,
    required this.statementDueDate,
    required this.idCreditCard,
    required this.totalPaid,
    required this.totalSpent,
    required this.amountLimit,
  });
}
