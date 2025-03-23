import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardTransactionEntity extends Entity implements ITransactionEntity {
  String description;

  @override
  double amount;

  @override
  DateTime date;

  String? idCategory;

  String? idCreditCard;
  String? idCreditCardBill;

  String? observation;

  CreditCardTransactionEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.amount,
    required this.date,
    required this.idCategory,
    required this.idCreditCard,
    required this.idCreditCardBill,
    required this.observation,
  });

  CreditCardTransactionEntity clone() {
    return CreditCardTransactionEntity(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      amount: amount,
      date: date,
      idCategory: idCategory,
      idCreditCard: idCreditCard,
      idCreditCardBill: idCreditCardBill,
      observation: observation,
    );
  }
}
