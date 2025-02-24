import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/bill_status_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';

class CreditCardBillEntity extends Entity {
  DateTime billClosingDate;
  DateTime billDueDate;

  final String idCreditCard;

  List<CreditCardTransactionEntity> transactions = [];

  double get totalSpent => transactions.map((transaction) => transaction.amount > 0 ? transaction.amount : 0).sum.toDouble();

  double get totalPaid => transactions.map((transaction) => transaction.amount < 0 ? transaction.amount : 0).sum.toDouble();

  //totalPaid terá valor negativo, portanto, 1000 + (-100).
  double get billAmount => (totalSpent + totalPaid).truncateFractionalDigits(2);

  BillStatusEnum get status {
    final now = DateTime.now();

    if (now == billClosingDate || now.isAfter(billClosingDate)) {
      if (billAmount <= 0) return BillStatusEnum.paid;

      if (now == billDueDate || now.isBefore(billDueDate)) return BillStatusEnum.closed;
    }

    if (now.isAfter(billDueDate)) return BillStatusEnum.overdue;

    return BillStatusEnum.outstanding;
  }

  CreditCardBillEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.billClosingDate,
    required this.billDueDate,
    required this.idCreditCard,
    required this.transactions,
  });

  CreditCardBillEntity clone() {
    return CreditCardBillEntity(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      billClosingDate: billClosingDate,
      billDueDate: billDueDate,
      idCreditCard: idCreditCard,
      transactions: transactions.map((transaction) => transaction.clone()).toList(),
    );
  }
}
