import 'package:finan_master_app/shared/infra/models/model.dart';

class IncomeModel extends Model {
  String description;
  double amount;
  DateTime date;
  bool received;
  String? observation;

  String idAccount;
  String idCategory;

  IncomeModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.amount,
    required this.date,
    required this.received,
    required this.observation,
    required this.idAccount,
    required this.idCategory,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'received': received ? 1 : 0,
      'observation': observation,
      'id_account': idAccount,
      'id_category': idCategory,
    };
  }

  @override
  IncomeModel clone() {
    return IncomeModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      amount: amount,
      date: date,
      received: received,
      observation: observation,
      idAccount: idAccount,
      idCategory: idCategory,
    );
  }
}
