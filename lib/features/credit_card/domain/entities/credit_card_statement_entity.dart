import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardStatementEntity extends Entity {
  DateTime statementClosingDate;
  DateTime statementDueDate;

  final String idCreditCard;

  final double amountLimit;

  List<CreditCardTransactionEntity> transactions = [];

  double get totalSpent => transactions.map((transaction) => transaction.amount > 0 ? transaction.amount : 0).sum.toDouble();

  double get totalPaid => transactions.map((transaction) => transaction.amount < 0 ? transaction.amount : 0).sum.toDouble();

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
    required this.amountLimit,
    required this.transactions,
  });
}
