import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class TransactionEntity extends Entity {
  double amount;
  TransactionTypeEnum type;
  DateTime date;

  String? idAccount;

  TransactionEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.amount,
    required this.type,
    required this.date,
    required this.idAccount,
  });
}
