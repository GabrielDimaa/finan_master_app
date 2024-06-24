import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardStatementModel extends Model {
  final DateTime statementClosingDate;
  final DateTime statementDueDate;

  final String idCreditCard;

  final List<CreditCardTransactionModel> transactions;

  final bool paid;

  double get totalSpent => transactions.map((transaction) => transaction.amount > 0 ? transaction.amount : 0).sum.toDouble();

  double get totalPaid => transactions.map((transaction) => transaction.amount < 0 ? transaction.amount : 0).sum.toDouble();

  //totalPaid terá valor negativo, portanto, 1000 + (-100).
  double get statementAmount => (totalSpent + totalPaid).truncateFractionalDigits(2);

  CreditCardStatementModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.statementClosingDate,
    required this.statementDueDate,
    required this.idCreditCard,
    required this.transactions,
    required this.paid,
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
      transactions: transactions.map((transaction) => transaction.clone()).toList(),
      paid: paid,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'statement_closing_date': statementClosingDate.toIso8601String(),
      'statement_due_date': statementDueDate.toIso8601String(),
      'id_credit_card': idCreditCard,
      'paid': paid ? 1 : 0,
    };
  }
}
