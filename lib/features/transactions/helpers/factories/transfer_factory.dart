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
      idAccountFrom: entity.idAccountFrom!,
      idAccountTo: entity.idAccountTo!,
    );
  }

  static TransferEntity toEntity(TransferModel model) {
    return TransferEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      amount: model.amount,
      date: model.date,
      idAccountFrom: model.idAccountFrom,
      idAccountTo: model.idAccountTo,
    );
  }
}
