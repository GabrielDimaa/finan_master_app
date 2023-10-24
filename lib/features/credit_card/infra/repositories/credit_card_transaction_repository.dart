import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class CreditCardTransactionRepository implements ICreditCardTransactionRepository {
  final ICreditCardTransactionLocalDataSource _dataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  CreditCardTransactionRepository({
    required ICreditCardTransactionLocalDataSource dataSource,
    required IDatabaseLocalTransaction dbTransaction,
  })  : _dataSource = dataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity) async {
    final CreditCardTransactionModel transaction = await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(entity));
    return CreditCardTransactionFactory.toEntity(transaction);
  }

  @override
  Future<void> saveMany(List<CreditCardTransactionEntity> transactions, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((newTxn) async {
        for (final transaction in transactions) {
          await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(transaction), txn: newTxn);
        }
      });
    } else {
      for (final transaction in transactions) {
        await _dataSource.upsert(CreditCardTransactionFactory.fromEntity(transaction), txn: txn);
      }
    }
  }

  @override
  Future<void> delete(CreditCardTransactionEntity entity) => _dataSource.delete(CreditCardTransactionFactory.fromEntity(entity));
}
