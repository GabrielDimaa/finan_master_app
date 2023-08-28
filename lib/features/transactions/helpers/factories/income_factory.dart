import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/category/helpers/factories/category_factory.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';

abstract class IncomeFactory {
  static IncomeModel fromEntity(IncomeEntity entity) {
    return IncomeModel(
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

  static IncomeEntity toEntity(IncomeModel model) {
    return IncomeEntity(
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
