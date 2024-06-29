import 'package:finan_master_app/features/account/infra/models/account_simple.dart';
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
      billClosingDay: entity.billClosingDay,
      billDueDay: entity.billDueDay,
      brand: entity.brand!,
      idAccount: entity.idAccount!,
      amountLimitUtilized: entity.amountLimitUtilized,
    );
  }

  static CreditCardEntity toEntity({required CreditCardModel model, required AccountSimpleModel accountModel}) {
    return CreditCardEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      amountLimit: model.amountLimit,
      billClosingDay: model.billClosingDay,
      billDueDay: model.billDueDay,
      brand: model.brand,
      idAccount: model.idAccount,
      descriptionAccount: accountModel.description,
      financialInstitutionAccount: accountModel.financialInstitution,
      amountLimitUtilized: model.amountLimitUtilized,
    );
  }
}
