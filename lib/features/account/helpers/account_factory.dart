import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';

abstract class AccountFactory {
  static AccountModel fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      balance: entity.balance,
      initialValue: entity.initialValue,
      financialInstitution: entity.financialInstitution!,
      includeTotalBalance: entity.includeTotalBalance,
    );
  }

  static AccountEntity toEntity(AccountModel model) {
    return AccountEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      description: model.description,
      balance: model.balance,
      initialValue: model.initialValue,
      financialInstitution: model.financialInstitution,
      includeTotalBalance: model.includeTotalBalance,
    );
  }
}
