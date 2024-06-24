import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardModel extends Model {
  final String description;
  final double amountLimit;
  final int statementClosingDay;
  final int statementDueDay;
  final CardBrandEnum brand;
  final String idAccount;

  double amountLimitUtilized;

  CreditCardModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.amountLimit,
    required this.statementClosingDay,
    required this.statementDueDay,
    required this.brand,
    required this.idAccount,
    required this.amountLimitUtilized,
  });

  @override
  CreditCardModel clone() {
    return CreditCardModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      amountLimit: amountLimit,
      statementClosingDay: statementClosingDay,
      statementDueDay: statementDueDay,
      brand: brand,
      idAccount: idAccount,
      amountLimitUtilized: amountLimitUtilized,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'amount_limit': amountLimit,
      'statement_closing_day': statementClosingDay,
      'statement_due_day': statementDueDay,
      'brand': brand.value,
      'id_account': idAccount,
    };
  }
}
