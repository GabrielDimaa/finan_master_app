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
      paid: entity.paid,
      observation: entity.observation,
      idAccount: entity.idAccount!,
      idCategory: entity.idCategory!,
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
      paid: model.paid,
      observation: model.observation,
      idAccount: model.idAccount,
      idCategory: model.idCategory,
    );
  }
}
