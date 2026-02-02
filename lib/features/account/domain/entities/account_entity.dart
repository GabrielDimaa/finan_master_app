import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';

class AccountEntity extends Entity {
  String description;
  double initialAmount;
  FinancialInstitutionEnum? financialInstitution;
  bool includeTotalBalance;

  final double transactionsAmount;

  double get balance => (initialAmount + transactionsAmount).toRound(2);

  AccountEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.transactionsAmount,
    required this.initialAmount,
    required this.financialInstitution,
    required this.includeTotalBalance,
  });

  AccountEntity clone() {
    return AccountEntity(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      transactionsAmount: transactionsAmount,
      initialAmount: initialAmount,
      financialInstitution: financialInstitution,
      includeTotalBalance: includeTotalBalance,
    );
  }
}
