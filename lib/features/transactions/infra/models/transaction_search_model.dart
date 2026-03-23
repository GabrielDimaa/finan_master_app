import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';

class TransactionSearchModel {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final bool paidOrReceived;

  final CategoryModel category;
  final AccountTransactionSearchModel? account;
  final CreditCardTransactionSearchModel? creditCard;

  TransactionSearchModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.paidOrReceived,
    required this.category,
    required this.account,
    required this.creditCard,
  }) : assert(account != null || creditCard != null);
}

class AccountTransactionSearchModel {
  final String id;
  final String description;
  final FinancialInstitutionEnum financialInstitution;

  AccountTransactionSearchModel({required this.id, required this.description, required this.financialInstitution});
}

class CreditCardTransactionSearchModel {
  final String id;
  final String description;
  final AccountTransactionSearchModel account;

  CreditCardTransactionSearchModel({required this.id, required this.description, required this.account});
}
