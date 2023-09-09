import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';

sealed class IncomeState {
  final IncomeEntity income;

  const IncomeState({required this.income});

  factory IncomeState.start() => StartIncomeState();

  IncomeState updateIncome(IncomeEntity income) => ChangedIncomeState(income: income);

  IncomeState setSaving() => SavingIncomeState(income: income);

  IncomeState changedIncome() => ChangedIncomeState(income: income);

  IncomeState setDeleting() => DeletingIncomeState(income: income);
}

class StartIncomeState extends IncomeState {
  StartIncomeState()
      : super(
          income: IncomeEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: '',
            observation: null,
            idCategory: null,
            transaction: null,
          ),
        );
}

class ChangedIncomeState extends IncomeState {
  const ChangedIncomeState({required super.income});
}

class SavingIncomeState extends IncomeState {
  const SavingIncomeState({required super.income});
}

class DeletingIncomeState extends IncomeState {
  const DeletingIncomeState({required super.income});
}
