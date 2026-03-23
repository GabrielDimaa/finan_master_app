import 'package:finan_master_app/features/transactions/domain/entities/transaction_search_entity.dart';

abstract interface class ITransactionRepository {
  Future<List<TransactionSearchEntity>> search({required String text, required int limit, required int offset});
}