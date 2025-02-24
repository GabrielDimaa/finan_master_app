import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class ExpenseEntity extends Entity implements ITransactionEntity {
  String description;
  late double _amount;

  bool paid;
  String? observation;

  String? idCategory;

  String? idCreditCard;
  String? idCreditCardTransaction;

  String? idAccount;

  @override
  DateTime date;

  @override
  double get amount => _amount;

  set amount(double value) => _amount = -value.abs();

  ExpenseEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required double amount,
    required this.date,
    required this.paid,
    required this.observation,
    required this.idAccount,
    required this.idCategory,
    required this.idCreditCard,
    required this.idCreditCardTransaction,
  }) {
    this.amount = amount;
  }
}
