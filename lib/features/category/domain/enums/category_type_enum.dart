import 'package:collection/collection.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

enum CategoryTypeEnum {
  expense(1),
  income(2);

  final int value;

  const CategoryTypeEnum(this.value);

  static CategoryTypeEnum? getByValue(int value) => CategoryTypeEnum.values.firstWhereOrNull((v) => v.value == value);
}

extension CategoryTypeExtension on CategoryTypeEnum {
  String get description => switch (this) {
        CategoryTypeEnum.expense => R.strings.expense,
        CategoryTypeEnum.income => R.strings.income,
      };

  String get descriptionPlural => switch (this) {
    CategoryTypeEnum.expense => R.strings.expenses,
    CategoryTypeEnum.income => R.strings.incomes,
  };
}
