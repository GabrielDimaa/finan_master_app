import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/category/helpers/factories/category_factory.dart';
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
      observation: entity.observation,
      category: CategoryFactory.fromEntity(entity.category!),
      account: AccountFactory.fromEntity(entity.account!),
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
      observation: model.observation,
      category: CategoryFactory.toEntity(model.category),
      account: AccountFactory.toEntity(model.account),
    );
  }
}
