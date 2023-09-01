import 'package:finan_master_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transaction_factory.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class TransferEntity extends Entity {
  late TransactionEntity _transactionFrom;
  late TransactionEntity _transactionTo;

  TransactionEntity get transactionFrom => _transactionFrom;

  TransactionEntity get transactionTo => _transactionTo;

  set transactionFrom(TransactionEntity value) => _transactionFrom = value..type = TransactionTypeEnum.transfer;

  set transactionTo(TransactionEntity value) => _transactionTo = value..type = TransactionTypeEnum.transfer;

  TransferEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required TransactionEntity? transactionFrom,
    required TransactionEntity? transactionTo,
  }) {
    transactionFrom = transactionFrom ?? TransactionFactory.newEntity(TransactionTypeEnum.transfer);
    transactionTo = transactionTo ?? TransactionFactory.newEntity(TransactionTypeEnum.transfer);
  }
}
