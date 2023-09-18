import 'package:finan_master_app/features/transactions/domain/entities/i_financial_operation_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/features/transactions/infra/models/i_financial_operation_model.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';

abstract class TransactionFactory {
  static TransactionModel fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      amount: entity.amount,
      type: entity.type,
      date: entity.date,
      idAccount: entity.idAccount!,
    );
  }

  static TransactionEntity toEntity(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      createdAt: model.createdAt,
      deletedAt: model.deletedAt,
      amount: model.amount,
      type: model.type,
      date: model.date,
      idAccount: model.idAccount,
    );
  }

  static TransactionEntity newEntity(TransactionTypeEnum transactionType) {
    return TransactionEntity(
      id: null,
      createdAt: null,
      deletedAt: null,
      amount: 0,
      type: transactionType,
      date: DateTime.now(),
      idAccount: null,
    );
  }
}
