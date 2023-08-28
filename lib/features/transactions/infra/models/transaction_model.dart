import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransactionModel extends Model {
  String? idAccount;
  double amount;
  TransactionTypeEnum typeTransaction;
  DateTime date;

  TransactionModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.idAccount,
    required this.amount,
    required this.typeTransaction,
    required this.date,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'id_account': idAccount,
      'amount': amount,
      'type_transaction': typeTransaction.value,
      'date': date.toIso8601String(),
    };
  }

  @override
  TransactionModel clone() {
    return TransactionModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      idAccount: idAccount,
      amount: amount,
      typeTransaction: typeTransaction,
      date: date,
    );
  }
}
