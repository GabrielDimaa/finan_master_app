import 'package:finan_master_app/features/transactions/domain/entities/transaction_search_entity.dart';
import 'package:finan_master_app/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:finan_master_app/features/transactions/helpers/factories/transaction_search_factory.dart';
import 'package:finan_master_app/features/transactions/infra/data_sources/i_transaction_data_source.dart';

class TransactionRepository implements ITransactionRepository {
  final ITransactionLocalDataSource _dataSource;

  TransactionRepository({required ITransactionLocalDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<List<TransactionSearchEntity>> search({required String text, required int limit, required int offset}) async {
    final result = await _dataSource.search(text: text, limit: limit, offset: offset);

    return result.map(TransactionSearchFactory.toEntity).toList();
  }
}
