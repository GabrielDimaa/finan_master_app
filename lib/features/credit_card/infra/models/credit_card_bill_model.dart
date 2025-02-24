import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardBillModel extends Model {
  final DateTime billClosingDate;
  final DateTime billDueDate;

  final String idCreditCard;

  final List<CreditCardTransactionModel> transactions;

  double get totalSpent => transactions.map((transaction) => transaction.amount > 0 ? transaction.amount : 0).sum.toDouble();

  double get totalPaid => transactions.map((transaction) => transaction.amount < 0 ? transaction.amount : 0).sum.toDouble();

  //totalPaid terá valor negativo, portanto, 1000 + (-100).
  double get billAmount => (totalSpent + totalPaid).truncateFractionalDigits(2);

  CreditCardBillModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.billClosingDate,
    required this.billDueDate,
    required this.idCreditCard,
    required this.transactions,
  });

  @override
  CreditCardBillModel clone() {
    return CreditCardBillModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      billClosingDate: billClosingDate,
      billDueDate: billDueDate,
      idCreditCard: idCreditCard,
      transactions: transactions.map((transaction) => transaction.clone()).toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'bill_closing_date': billClosingDate.toIso8601String(),
      'bill_due_date': billDueDate.toIso8601String(),
      'id_credit_card': idCreditCard,
    };
  }
}
