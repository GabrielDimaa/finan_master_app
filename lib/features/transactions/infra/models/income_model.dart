import 'package:finan_master_app/features/transactions/infra/models/i_transaction_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class IncomeModel extends Model implements ITransactionModel {
  String description;
  bool paid;
  String? observation;

  String idCategory;
  TransactionModel transaction;

  IncomeModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.paid,
    required this.observation,
    required this.idCategory,
    required this.transaction,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'paid': paid ? 1 : 0,
      'observation': observation,
      'id_category': idCategory,
      'id_transaction': transaction.id,
    };
  }

  @override
  IncomeModel clone() {
    return IncomeModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      paid: paid,
      observation: observation,
      idCategory: idCategory,
      transaction: transaction.clone(),
    );
  }
}
