import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';

class AccountSimpleModel {
  final String id;
  final String description;
  final FinancialInstitutionEnum financialInstitution;

  AccountSimpleModel({
    required this.id,
    required this.description,
    required this.financialInstitution,
  });
}
