import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';

abstract interface class IIncomeSave {
  Future<IncomeEntity> save(IncomeEntity entity);
}
