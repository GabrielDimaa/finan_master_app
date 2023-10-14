import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';

abstract class CreditCardTransactionFactory {
  static CreditCardTransactionModel fromEntity(CreditCardTransactionEntity entity) {
    return CreditCardTransactionModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      amount: entity.amount,
      date: entity.date,
      idCategory: entity.idCategory!,
      idCreditCard: entity.idCreditCard!,
      idCreditCardStatement: entity.idCreditCardStatement!,
      observation: entity.observation,
    );
  }

  static CreditCardTransactionEntity toEntity(CreditCardTransactionModel model) {
    return CreditCardTransactionEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      amount: model.amount,
      date: model.date,
      idCategory: model.idCategory,
      idCreditCard: model.idCreditCard,
      idCreditCardStatement: model.idCreditCardStatement,
      observation: model.observation,
    );
  }
}
