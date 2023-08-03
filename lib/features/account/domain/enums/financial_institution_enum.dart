import 'package:collection/collection.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

enum FinancialInstitutionEnum {
  wallet(1);

  final int value;

  const FinancialInstitutionEnum(this.value);

  static FinancialInstitutionEnum? getByValue(int value) => FinancialInstitutionEnum.values.firstWhereOrNull((v) => v.value == value);
}

extension FinancialInstitutionExtension on FinancialInstitutionEnum {
  String get description => switch (this) {
    FinancialInstitutionEnum.wallet => R.strings.wallet,
  };
}