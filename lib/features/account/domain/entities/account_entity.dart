import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class AccountEntity extends Entity {
  String description;
  String? idStatementInitialAmount;
  double initialAmount;
  FinancialInstitutionEnum? financialInstitution;
  bool includeTotalBalance;

  final double transactionsAmount;

  AccountEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.idStatementInitialAmount,
    required this.initialAmount,
    required this.financialInstitution,
    required this.includeTotalBalance,
    required this.transactionsAmount,
  });

  AccountEntity clone() {
    return AccountEntity(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      idStatementInitialAmount: idStatementInitialAmount,
      initialAmount: initialAmount,
      financialInstitution: financialInstitution,
      includeTotalBalance: includeTotalBalance,
      transactionsAmount: transactionsAmount,
    );
  }
}
