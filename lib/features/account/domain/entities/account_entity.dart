import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class AccountEntity extends Entity {
  String description;
  double balance;
  double initialValue;
  FinancialInstitutionEnum? financialInstitution;
  bool includeTotalBalance;

  AccountEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.balance,
    required this.initialValue,
    required this.financialInstitution,
    required this.includeTotalBalance,
  });
}
