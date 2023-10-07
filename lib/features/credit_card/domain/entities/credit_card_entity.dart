import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class CreditCardEntity extends Entity {
  String description;
  double limit;
  DateTime invoiceClosingDate;
  DateTime invoiceDueDate;
  CardBrandEnum? brand;
  String? idAccount;

  CreditCardEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.limit,
    required this.invoiceClosingDate,
    required this.invoiceDueDate,
    required this.brand,
    required this.idAccount,
  });
}
