import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';

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
      idCreditCardBill: entity.idCreditCardBill!,
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
      idCreditCardBill: model.idCreditCardBill,
      observation: model.observation,
    );
  }

  static ExpenseEntity toExpenseEntity(CreditCardTransactionEntity entity) {
    return ExpenseEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      description: entity.description,
      amount: entity.amount.abs(),
      date: DateTime.now(),
      paid: true,
      observation: entity.observation,
      idAccount: null,
      idCategory: entity.idCategory,
      idCreditCardTransaction: entity.id,
    );
  }
}
