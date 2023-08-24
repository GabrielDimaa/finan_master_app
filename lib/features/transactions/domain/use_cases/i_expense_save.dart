import 'package:finan_master_app/features/transactions/domain/entities/expense_entity.dart';
import 'package:finan_master_app/shared/classes/result.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';

abstract interface class IExpenseSave {
  Future<Result<ExpenseEntity, BaseException>> save(ExpenseEntity entity);
}
