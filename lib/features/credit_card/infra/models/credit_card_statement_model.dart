import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardStatementModel extends Model {
  final DateTime invoiceClosingDate;
  final DateTime invoiceDueDate;

  final String idCreditCard;

  final double statementAmount;
  final double amountLimit;

  CreditCardStatementModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.invoiceClosingDate,
    required this.invoiceDueDate,
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
      invoiceClosingDate: invoiceClosingDate,
      invoiceDueDate: invoiceDueDate,
      idCreditCard: idCreditCard,
      statementAmount: statementAmount,
      amountLimit: amountLimit,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'invoice_closing_date': invoiceClosingDate.toIso8601String(),
      'invoice_due_date': invoiceDueDate.toIso8601String(),
      'id_credit_card': idCreditCard,
    };
  }
}
