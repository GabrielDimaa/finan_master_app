import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';

class TransactionSearchEntity {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final bool paidOrReceived;

  final CategoryEntity category;
  final AccountTransactionSearchEntity? account;
  final CreditCardTransactionSearchEntity? creditCard;

  TransactionSearchEntity({
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

class AccountTransactionSearchEntity {
  final String id;
  final String description;
  final FinancialInstitutionEnum financialInstitution;

  AccountTransactionSearchEntity({required this.id, required this.description, required this.financialInstitution});
}

class CreditCardTransactionSearchEntity {
  final String id;
  final String description;
  final AccountTransactionSearchEntity account;

  CreditCardTransactionSearchEntity({required this.id, required this.description, required this.account});
}
