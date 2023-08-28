import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';

class TransferEntity extends TransactionEntity {
  AccountEntity? accountFrom;
  AccountEntity? accountTo;

  @override
  String? get idAccount => accountTo?.id;

  TransferEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required super.amount,
    required super.date,
    required this.accountFrom,
    required this.accountTo,
  }) : super(
          idAccount: accountTo?.id,
          typeTransaction: TransactionTypeEnum.transfer,
        );
}
