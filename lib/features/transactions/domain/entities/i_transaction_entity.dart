import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';

abstract interface class ITransactionEntity {
  double get amount;

  DateTime get date;

  CategoryTypeEnum? get categoryType;
}
