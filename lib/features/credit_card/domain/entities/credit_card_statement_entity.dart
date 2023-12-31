import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/statement_status_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';

class CreditCardStatementEntity extends Entity {
  DateTime statementClosingDate;
  DateTime statementDueDate;

  final String idCreditCard;

  final double amountLimit;

  List<CreditCardTransactionEntity> transactions = [];

  bool paid;

  double get totalSpent => transactions.map((transaction) => transaction.amount > 0 ? transaction.amount : 0).sum.toDouble();

  double get totalPaid => transactions.map((transaction) => transaction.amount < 0 ? transaction.amount : 0).sum.toDouble();

  //totalPaid terá valor negativo, portanto, 1000 + (-100).
  double get statementAmount => (totalSpent + totalPaid).truncateFractionalDigits(2);

  double get amountAvailable => (amountLimit - statementAmount).truncateFractionalDigits(2);

  StatementStatusEnum get status {
    final dateTimeNow = DateTime.now();
    if (totalPaid == 0 && totalSpent == 0) return StatementStatusEnum.noMovements;
    if (paid) return StatementStatusEnum.paid;
    if ((dateTimeNow == statementClosingDate || dateTimeNow.isAfter(statementClosingDate)) && (dateTimeNow == statementDueDate || dateTimeNow.isBefore(statementDueDate))) return StatementStatusEnum.closed;
    if (dateTimeNow.isAfter(statementDueDate)) return StatementStatusEnum.overdue;
    return StatementStatusEnum.outstanding;
  }

  CreditCardStatementEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.statementClosingDate,
    required this.statementDueDate,
    required this.idCreditCard,
    required this.amountLimit,
    required this.transactions,
    required this.paid,
  });

  CreditCardStatementEntity clone() {
    return CreditCardStatementEntity(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      statementClosingDate: statementClosingDate,
      statementDueDate: statementDueDate,
      idCreditCard: idCreditCard,
      amountLimit: amountLimit,
      transactions: transactions.map((transaction) => transaction.clone()).toList(),
      paid: paid,
    );
  }
}
