import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transaction_factory.dart';
import 'package:finan_master_app/features/transactions/infra/models/expense_model.dart';

abstract class ExpenseFactory {
  static ExpenseModel fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      observation: entity.observation,
      idCategory: entity.idCategory!,
      idCreditCardTransaction: entity.idCreditCardTransaction!,
      transaction: TransactionFactory.fromEntity(entity.transaction),
    );
  }

  static ExpenseEntity toEntity(ExpenseModel model) {
    return ExpenseEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      observation: model.observation,
      idCategory: model.idCategory,
      idCreditCardTransaction: model.idCreditCardTransaction,
      transaction: TransactionFactory.toEntity(model.transaction),
    );
  }
}
