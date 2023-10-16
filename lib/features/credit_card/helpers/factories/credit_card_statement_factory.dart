import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_statement_model.dart';

abstract class CreditCardStatementFactory {
  static CreditCardStatementModel fromEntity(CreditCardStatementEntity entity) {
    return CreditCardStatementModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      statementClosingDate: entity.statementClosingDate,
      statementDueDate: entity.statementDueDate,
      idCreditCard: entity.idCreditCard,
      statementAmount: entity.statementAmount,
      amountLimit: entity.amountLimit,
    );
  }

  static CreditCardStatementEntity toEntity(CreditCardStatementModel model) {
    return CreditCardStatementEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      statementClosingDate: model.statementClosingDate,
      statementDueDate: model.statementDueDate,
      idCreditCard: model.idCreditCard,
      statementAmount: model.statementAmount,
      amountLimit: model.amountLimit,
    );
  }
}
