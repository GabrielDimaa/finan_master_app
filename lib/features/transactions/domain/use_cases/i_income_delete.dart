import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';

abstract interface class IIncomeDelete {
  Future<void> delete(IncomeEntity entity);
}
