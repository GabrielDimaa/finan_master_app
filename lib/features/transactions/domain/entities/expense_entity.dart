import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finan_master_app/features/transactions/domain/enums/transaction_type_enum.dart';

class ExpenseEntity extends TransactionEntity {
  String description;
  String? observation;

  CategoryEntity? category;
  AccountEntity? account;

  @override
  String? get idAccount => account?.id;

  ExpenseEntity({
    required super.id,
    required super.createdAt,
    required super.deletedAt,
    required super.amount,
    required super.date,
    required this.description,
    required this.observation,
    required this.category,
    required this.account,
  }) : super(
          idAccount: account?.id,
          typeTransaction: TransactionTypeEnum.expense,
        );
}
