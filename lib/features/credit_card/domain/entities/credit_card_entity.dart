import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardEntity extends Entity {
  String description;
  double amountLimit;
  int statementClosingDay;
  int statementDueDay;
  CardBrandEnum? brand;
  String? idAccount;

  CreditCardEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.amountLimit,
    required this.statementClosingDay,
    required this.statementDueDay,
    required this.brand,
    required this.idAccount,
  });
}
