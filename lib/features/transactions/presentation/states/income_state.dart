import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';

sealed class IncomeState {
  final IncomeEntity income;

  const IncomeState({required this.income});

  factory IncomeState.start() => StartIncomeState();

  IncomeState setIncome(IncomeEntity income) => ChangedIncomeState(income: income);

  IncomeState setSaving() => SavingIncomeState(income: income);

  IncomeState changedIncome() => ChangedIncomeState(income: income);

  IncomeState setDeleting() => DeletingIncomeState(income: income);

  IncomeState setError(String message) => ErrorIncomeState(message, income: income);
}

class StartIncomeState extends IncomeState {
  StartIncomeState()
      : super(
          income: IncomeEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: '',
            amount: 0,
            date: DateTime.now(),
            paid: true,
            observation: null,
            idAccount: null,
            idCategory: null,
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

class ErrorIncomeState extends IncomeState {
  final String message;

  const ErrorIncomeState(this.message, {required super.income});
}
