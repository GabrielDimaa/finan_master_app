import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardTransactionEntity extends Entity {
  String description;
  double amount;
  DateTime date;
  String? idCategory;

  String? idCreditCard;
  String? idCreditCardStatement;

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
    required this.idCreditCardStatement,
    required this.observation,
  });
}
