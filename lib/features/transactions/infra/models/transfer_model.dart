import 'package:finan_master_app/features/account/infra/models/account_model.dart';
import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/features/transactions/infra/models/transaction_model.dart';

class TransferModel extends TransactionModel {
  AccountModel? accountFrom;
  AccountModel? accountTo;

  @override
  String? get idAccount => accountTo?.id;

  TransferModel({
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
