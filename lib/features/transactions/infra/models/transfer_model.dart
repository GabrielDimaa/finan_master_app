import 'package:finan_master_app/shared/infra/models/model.dart';

class TransferModel extends Model {
  final double amount;
  final DateTime date;

  final String idAccountFrom;
  final String idAccountTo;

  TransferModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.amount,
    required this.date,
    required this.idAccountFrom,
    required this.idAccountTo,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'amount': amount,
      'date': date.toIso8601String(),
      'id_account_from': idAccountFrom,
      'id_account_to': idAccountTo,
    };
  }

  @override
  TransferModel clone() {
    return TransferModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      amount: amount,
      date: date,
      idAccountFrom: idAccountFrom,
      idAccountTo: idAccountTo,
    );
  }
}
