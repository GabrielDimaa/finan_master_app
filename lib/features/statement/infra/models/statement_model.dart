import 'package:finan_master_app/shared/infra/models/model.dart';

class StatementModel extends Model {
  final double amount;
  final DateTime date;

  final String idAccount;

  final String? idExpense;
  final String? idIncome;
  final String? idTransfer;

  StatementModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.amount,
    required this.date,
    required this.idAccount,
    required this.idExpense,
    required this.idIncome,
    required this.idTransfer,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'amount': amount,
      'date': date.toIso8601String(),
      'id_account': idAccount,
      'id_expense': idExpense,
      'id_income': idIncome,
      'id_transfer': idTransfer,
    };
  }

  @override
  StatementModel clone() {
    return StatementModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      amount: amount,
      date: date,
      idAccount: idAccount,
      idExpense: idExpense,
      idIncome: idIncome,
      idTransfer: idTransfer,
    );
  }
}
