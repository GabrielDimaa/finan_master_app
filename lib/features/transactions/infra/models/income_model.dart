import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';

class IncomeModel extends TransactionModel {
  String description;
  String? observation;

  CategoryModel category;
  AccountModel account;

  @override
  String? get idAccount => account.id;

  IncomeModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required super.amount,
    required super.date,
    required this.description,
    required this.observation,
    required this.category,
    required this.account,
  }) : super(
    idAccount: account.id,
    typeTransaction: TransactionTypeEnum.income,
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'observation': observation,
      'id_category': category.id,
      'id_account': idAccount,
    };
  }

  @override
  IncomeModel clone() {
    return IncomeModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      amount: amount,
      date: date,
      description: description,
      observation: observation,
      category: category,
      account: account,
    );
  }
}
