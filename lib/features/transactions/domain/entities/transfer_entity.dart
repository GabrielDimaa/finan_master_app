import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/shared/domain/entities/entity.dart';

class TransferEntity extends Entity {
  double value;
  DateTime date;

  AccountEntity? accountFrom;
  AccountEntity? accountTo;

  TransferEntity({
    required super.createdAt,
    required super.deletedAt,
    required this.value,
    required this.date,
    required this.accountFrom,
    required this.accountTo,
  });
}
