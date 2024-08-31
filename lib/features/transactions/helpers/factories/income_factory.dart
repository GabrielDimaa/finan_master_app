import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transaction_factory.dart';
import 'package:finan_master_app/features/transactions/infra/models/income_model.dart';

abstract class IncomeFactory {
  static IncomeModel fromEntity(IncomeEntity entity) {
    return IncomeModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      paid: entity.paid,
      observation: entity.observation,
      idCategory: entity.idCategory!,
      transaction: TransactionFactory.fromEntity(entity.transaction),
    );
  }

  static IncomeEntity toEntity(IncomeModel model) {
    return IncomeEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      paid: model.paid,
      observation: model.observation,
      idCategory: model.idCategory,
      transaction: TransactionFactory.toEntity(model.transaction),
    );
  }
}
