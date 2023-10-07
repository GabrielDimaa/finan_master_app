import 'package:finan_master_app/features/credit_card/domain/enums/brand_card_enum.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardModel extends Model {
  String description;
  double limit;
  int invoiceClosingDay;
  int invoiceDueDay;
  CardBrandEnum brand;
  String idAccount;

  CreditCardModel({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.limit,
    required this.invoiceClosingDay,
    required this.invoiceDueDay,
    required this.brand,
    required this.idAccount,
  });

  @override
  CreditCardModel clone() {
    return CreditCardModel(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      description: description,
      limit: limit,
      invoiceClosingDay: invoiceClosingDay,
      invoiceDueDay: invoiceDueDay,
      brand: brand,
      idAccount: idAccount,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseMap(),
      'description': description,
      'limit': limit,
      'invoice_closing_day': invoiceClosingDay,
      'invoice_due_day': invoiceDueDay,
      'brand': brand.value,
      'id_account': idAccount,
    };
  }
}
