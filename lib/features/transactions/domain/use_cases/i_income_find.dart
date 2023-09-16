import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';

abstract interface class IIncomeFind {
  Future<List<IncomeEntity>> findByPeriod(DateTime start, DateTime end);
}
