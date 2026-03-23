import 'package:finan_master_app/features/transactions/infra/models/transaction_search_model.dart';

abstract interface class ITransactionLocalDataSource {
  Future<List<TransactionSearchModel>> search({required String text, required int limit, required int offset});
}