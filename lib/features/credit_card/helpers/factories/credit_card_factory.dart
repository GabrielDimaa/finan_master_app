import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';

abstract class CreditCardFactory {
  static CreditCardModel fromEntity(CreditCardEntity entity) {
    return CreditCardModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      amountLimit: entity.amountLimit,
      invoiceClosingDay: entity.invoiceClosingDay,
      invoiceDueDay: entity.invoiceDueDay,
      brand: entity.brand!,
      idAccount: entity.idAccount!,
    );
  }

  static CreditCardEntity toEntity(CreditCardModel model) {
    return CreditCardEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      amountLimit: model.amountLimit,
      invoiceClosingDay: model.invoiceClosingDay,
      invoiceDueDay: model.invoiceDueDay,
      brand: model.brand,
      idAccount: model.idAccount,
    );
  }
}
