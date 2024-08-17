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
      'account_step_done': accountStepDone,
      'credit_card_step_done': creditCardStepDone,
      'income_step_done': incomeStepDone,
      'expense_step_done': expenseStepDone,
    };
  }
}
