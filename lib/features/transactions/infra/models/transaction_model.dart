import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class TransactionModel extends Model {
  double amount;
  TransactionTypeEnum type;
  DateTime date;

  String idAccount;

  TransactionModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.amount,
    required this.type,
    required this.date,
    required this.idAccount,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'amount': amount,
      'type': type.value,
      'date': date.toIso8601String(),
      'id_account': idAccount,
    };
  }

  @override
  TransactionModel clone() {
    return TransactionModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      amount: amount,
      type: type,
      date: date,
      idAccount: idAccount,
    );
  }
}
