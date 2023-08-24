import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

abstract interface class IIncomeRepository {
  Future<Result<IncomeEntity, BaseException>> save(IncomeEntity entity);
}
