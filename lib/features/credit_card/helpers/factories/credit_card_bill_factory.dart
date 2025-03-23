import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_bill_model.dart';

abstract class CreditCardBillFactory {
  static CreditCardBillModel fromEntity(CreditCardBillEntity entity) {
    return CreditCardBillModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      billClosingDate: entity.billClosingDate,
      billDueDate: entity.billDueDate,
      idCreditCard: entity.idCreditCard,
      transactions: entity.transactions.map((transaction) => CreditCardTransactionFactory.fromEntity(transaction)).toList(),
    );
  }

  static CreditCardBillEntity toEntity(CreditCardBillModel model) {
    return CreditCardBillEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      billClosingDate: model.billClosingDate,
      billDueDate: model.billDueDate,
      idCreditCard: model.idCreditCard,
      transactions: model.transactions.map((transaction) => CreditCardTransactionFactory.toEntity(transaction)).toList(),
    );
  }
}
