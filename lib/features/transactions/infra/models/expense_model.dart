import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class ExpenseModel extends Model {
  String description;
  String? observation;

  String idCategory;

  TransactionModel transaction;

  ExpenseModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.observation,
    required this.idCategory,
    required this.transaction,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'observation': observation,
      'id_category': idCategory,
      'id_transaction': transaction.id,
    };
  }

  @override
  ExpenseModel clone() {
    return ExpenseModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      observation: observation,
      idCategory: idCategory,
      transaction: transaction.clone(),
    );
  }
}
