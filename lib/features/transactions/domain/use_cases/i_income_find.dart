import 'package:finan_master_app/features/transactions/domain/entities/income_entity.dart';
import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';

abstract interface class IIncomeFind {
  Future<List<TransactionByTextEntity>> findByText(String text);

  Future<IncomeEntity?> findById(String id);
}
