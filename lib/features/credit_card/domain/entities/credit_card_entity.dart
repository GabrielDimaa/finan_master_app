import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardEntity extends Entity {
  String description;
  double amountLimit;
  int billClosingDay;
  int billDueDay;
  CardBrandEnum? brand;

  String? idAccount;
  String descriptionAccount;
  FinancialInstitutionEnum? financialInstitutionAccount;

  final double amountLimitUtilized;

  CreditCardEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.amountLimit,
    required this.billClosingDay,
    required this.billDueDay,
    required this.brand,
    required this.idAccount,
    required this.descriptionAccount,
    required this.financialInstitutionAccount,
    required this.amountLimitUtilized,
  });
}
