import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardTransactionModel extends Model {
  String description;
  double amount;
  DateTime date;
  String idCategory;

  String idCreditCard;
  String idCreditCardStatement;

  String? observation;

  CreditCardTransactionModel({
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
      idCreditCardStatement: idCreditCardStatement,
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
      'id_credit_card_statement': idCreditCardStatement,
      'observation': observation,
    };
  }
}
