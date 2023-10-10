import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/transactions/domain/entities/i_transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transaction_factory.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class IncomeEntity extends Entity implements ITransactionEntity {
  String description;
  String? observation;

  String? idCategory;

  late TransactionEntity _transaction;

  TransactionEntity get transaction => _transaction;

  set transaction(TransactionEntity value) => _transaction = value..type = TransactionTypeEnum.income;

  set amount(double value) => _transaction.amount = value;

  @override
  double get amount => transaction.amount;

  @override
  DateTime get date => transaction.date;

  @override
  CategoryTypeEnum? get categoryType => CategoryTypeEnum.income;

  IncomeEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required this.description,
    required this.observation,
    required this.idCategory,
    required TransactionEntity? transaction,
  }) {
    this.transaction = transaction ?? TransactionFactory.newEntity(TransactionTypeEnum.income);
  }
}
