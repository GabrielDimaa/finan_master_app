import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class TransactionEntity extends Entity {
  String? idAccount;
  double amount;
  TransactionTypeEnum typeTransaction;
  DateTime date;

  TransactionEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.idAccount,
    required this.amount,
    required this.typeTransaction,
    required this.date,
  });
}
