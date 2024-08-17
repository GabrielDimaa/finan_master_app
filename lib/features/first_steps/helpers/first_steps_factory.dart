import 'package:finan_master_app/features/first_steps/domain/entities/first_steps_entity.dart';
import 'package:finan_master_app/features/first_steps/infra/models/first_steps_model.dart';

abstract class FirstStepsFactory {
  static FirstStepsModel fromEntity(FirstStepsEntity entity) {
    return FirstStepsModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      accountStepDone: entity.accountStepDone,
      creditCardStepDone: entity.creditCardStepDone,
      incomeStepDone: entity.incomeStepDone,
      expenseStepDone: entity.expenseStepDone,
    );
  }

  static FirstStepsEntity toEntity({required FirstStepsModel model}) {
    return FirstStepsEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      accountStepDone: model.accountStepDone,
      creditCardStepDone: model.creditCardStepDone,
      incomeStepDone: model.incomeStepDone,
      expenseStepDone: model.expenseStepDone,
    );
  }

  static FirstStepsEntity newEntity() {
    return FirstStepsEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      accountStepDone: false,
      creditCardStepDone: false,
      incomeStepDone: false,
      expenseStepDone: false,
    );
  }
}
