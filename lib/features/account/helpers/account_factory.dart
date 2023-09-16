import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/infra/models/account_model.dart';

abstract class AccountFactory {
  static AccountModel fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      description: entity.description,
      transactionsAmount: entity.transactionsAmount,
      initialValue: entity.initialAmount,
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
      transactionsAmount: model.transactionsAmount,
      initialAmount: model.initialValue,
      financialInstitution: model.financialInstitution,
      includeTotalBalance: model.includeTotalBalance,
    );
  }
}
