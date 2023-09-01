import 'package:finan_master_app/features/transactions/domain/entities/transfer_entity.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transaction_factory.dart';
import 'package:finan_master_app/features/transactions/infra/models/transfer_model.dart';

abstract class TransferFactory {
  static TransferModel fromEntity(TransferEntity entity) {
    return TransferModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      transactionFrom: TransactionFactory.fromEntity(entity.transactionFrom),
      transactionTo: TransactionFactory.fromEntity(entity.transactionTo),
    );
  }

  static TransferEntity toEntity(TransferModel model) {
    return TransferEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      transactionFrom: TransactionFactory.toEntity(model.transactionFrom),
      transactionTo: TransactionFactory.toEntity(model.transactionTo),
    );
  }
}
