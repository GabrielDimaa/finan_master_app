import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class IncomeEntity extends Entity implements ITransactionEntity {
  String description;

  @override
  double amount;

  @override
  DateTime date;

  bool paid;
  String? observation;

  String? idAccount;
  String? idCategory;

  IncomeEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.amount,
    required this.date,
    required this.paid,
    required this.observation,
    required this.idAccount,
    required this.idCategory,
  });
}
