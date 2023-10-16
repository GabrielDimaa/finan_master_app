import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardStatementEntity extends Entity {
  DateTime invoiceClosingDate;
  DateTime invoiceDueDate;

  final String idCreditCard;

  final double statementAmount;
  final double amountLimit;

  CreditCardStatementEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.invoiceClosingDate,
    required this.invoiceDueDate,
    required this.idCreditCard,
    required this.statementAmount,
    required this.amountLimit,
  });
}
