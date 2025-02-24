import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';

abstract class ExpenseFactory {
  static ExpenseModel fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      amount: entity.amount,
      date: entity.date,
      paid: entity.paid,
      observation: entity.observation,
      idAccount: entity.idAccount!,
      idCategory: entity.idCategory!,
      idCreditCard: entity.idCreditCard,
      idCreditCardTransaction: entity.idCreditCardTransaction,
    );
  }

  static ExpenseEntity toEntity(ExpenseModel model) {
    return ExpenseEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      amount: model.amount,
      date: model.date,
      paid: model.paid,
      observation: model.observation,
      idAccount: model.idAccount,
      idCategory: model.idCategory,
      idCreditCard: model.idCreditCard,
      idCreditCardTransaction: model.idCreditCardTransaction,
    );
  }
}
