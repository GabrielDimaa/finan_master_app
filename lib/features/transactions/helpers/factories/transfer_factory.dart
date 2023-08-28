import 'package:finan_master_app/features/account/helpers/account_factory.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';

abstract class TransferFactory {
  static TransferModel fromEntity(TransferEntity entity) {
    return TransferModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      amount: entity.amount,
      date: entity.date,
      accountFrom: AccountFactory.fromEntity(entity.accountFrom!),
      accountTo: AccountFactory.fromEntity(entity.accountTo!),
    );
  }

  static TransferEntity toEntity(TransferModel model) {
    return TransferEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      amount: model.amount,
      date: model.date,
      accountFrom: AccountFactory.toEntity(model.accountFrom!),
      accountTo: AccountFactory.toEntity(model.accountTo!),
    );
  }
}
