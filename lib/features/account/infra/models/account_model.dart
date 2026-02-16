import 'package:finan_master_app/features/account/domain/enums/financial_institution_enum.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class AccountModel extends Model {
  final String description;
  final String? idStatementInitialAmount;
  final double initialAmount;
  final FinancialInstitutionEnum financialInstitution;
  final bool includeTotalBalance;

  final double transactionsAmount;

  AccountModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.transactionsAmount,
    required this.idStatementInitialAmount,
    required this.initialAmount,
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
      transactionsAmount: transactionsAmount,
      idStatementInitialAmount: idStatementInitialAmount,
      initialAmount: initialAmount,
      financialInstitution: financialInstitution,
      includeTotalBalance: includeTotalBalance,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'id_statement_initial_amount': idStatementInitialAmount,
      'financial_institution': financialInstitution.value,
      'include_total_balance': includeTotalBalance ? 1 : 0,
    };
  }
}
