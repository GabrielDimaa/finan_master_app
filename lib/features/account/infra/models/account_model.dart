import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class AccountModel extends Model {
  String description;
  double balance;
  double initialValue;
  FinancialInstitutionEnum financialInstitution;
  bool includeTotalBalance;

  AccountModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.balance,
    required this.initialValue,
    required this.financialInstitution,
    required this.includeTotalBalance,
  });

  @override
  AccountModel clone() {
    return AccountModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      balance: balance,
      initialValue: initialValue,
      financialInstitution: financialInstitution,
      includeTotalBalance: includeTotalBalance,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'balance': balance,
      'initial_value': initialValue,
      'financial_institution': financialInstitution.value,
      'include_total_balance': includeTotalBalance ? 1 : 0,
    };
  }
}
