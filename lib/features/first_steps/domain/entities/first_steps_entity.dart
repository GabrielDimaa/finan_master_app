import 'package:finan_master_app/shared/domain/entities/entity.dart';

class FirstStepsEntity extends Entity {
  bool accountStepDone;
  bool creditCardStepDone;
  bool incomeStepDone;
  bool expenseStepDone;

  bool get done => accountStepDone && creditCardStepDone && incomeStepDone && expenseStepDone;

  List<bool> get _steps => [accountStepDone, creditCardStepDone, incomeStepDone, expenseStepDone];

  int totalSteps() => _steps.length;

  int totalStepsDone() => _steps.where((e) => e).length;

  set done(bool value) => accountStepDone = creditCardStepDone = incomeStepDone = expenseStepDone = value;

  FirstStepsEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.accountStepDone,
    required this.creditCardStepDone,
    required this.incomeStepDone,
    required this.expenseStepDone,
  });
}
