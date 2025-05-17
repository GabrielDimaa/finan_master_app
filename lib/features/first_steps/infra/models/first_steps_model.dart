import 'package:finan_master_app/shared/infra/models/model.dart';

class FirstStepsModel extends Model {
  final bool accountStepDone;
  final bool creditCardStepDone;
  final bool incomeStepDone;
  final bool expenseStepDone;

  FirstStepsModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.accountStepDone,
    required this.creditCardStepDone,
    required this.incomeStepDone,
    required this.expenseStepDone,
  });

  @override
  FirstStepsModel clone() {
    return FirstStepsModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      accountStepDone: accountStepDone,
      creditCardStepDone: creditCardStepDone,
      incomeStepDone: incomeStepDone,
      expenseStepDone: expenseStepDone,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'account_step_done': accountStepDone ? 1 : 0,
      'credit_card_step_done': creditCardStepDone ? 1 : 0,
      'income_step_done': incomeStepDone ? 1 : 0,
      'expense_step_done': expenseStepDone ? 1 : 0,
    };
  }
}
