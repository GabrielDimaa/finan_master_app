import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardTransactionModel extends Model {
  final String description;
  final double amount;
  final DateTime date;
  final String idCategory;

  final String idCreditCard;
  final String idCreditCardBill;

  final String? observation;

  CreditCardTransactionModel({
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

  @override
  CreditCardTransactionModel clone() {
    return CreditCardTransactionModel(
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

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'id_category': idCategory,
      'id_credit_card': idCreditCard,
      'id_credit_card_bill': idCreditCardBill,
      'observation': observation,
    };
  }
}
