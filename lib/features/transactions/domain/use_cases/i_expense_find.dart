import 'package:finan_master_app/features/transactions/domain/entities/transaction_by_text_entity.dart';

abstract interface class IExpenseFind {
  Future<List<TransactionByTextEntity>> findByText(String text);
}
