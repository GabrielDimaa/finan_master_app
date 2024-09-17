import 'package:finan_master_app/features/statement/domain/entities/statement_entity.dart';
import 'package:finan_master_app/features/statement/infra/models/statement_model.dart';
import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';

abstract class StatementFactory {
  static StatementModel fromEntity(StatementEntity entity) {
    return StatementModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      amount: entity.amount,
      date: entity.date,
      idAccount: entity.idAccount,
      idExpense: entity.idExpense,
      idIncome: entity.idIncome,
      idTransfer: entity.idTransfer,
    );
  }

  static StatementEntity toEntity(StatementModel model) {
    return StatementEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      amount: model.amount,
      date: model.date,
      idAccount: model.idAccount,
      idExpense: model.idExpense,
      idIncome: model.idIncome,
      idTransfer: model.idTransfer,
    );
  }

  static StatementEntity fromExpense(ExpenseEntity entity) {
    return StatementEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      amount: entity.amount,
      date: entity.date,
      idAccount: entity.idAccount!,
      idExpense: entity.id,
      idIncome: null,
      idTransfer: null,
    );
  }

  static StatementEntity fromIncome(IncomeEntity entity) {
    return StatementEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      amount: entity.amount,
      date: entity.date,
      idAccount: entity.idAccount!,
      idExpense: null,
      idIncome: entity.id,
      idTransfer: null,
    );
  }
}
