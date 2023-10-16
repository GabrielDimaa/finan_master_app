import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_statement_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_statement_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class CreditCardStatementRepository implements ICreditCardStatementRepository {
  final ICreditCardStatementLocalDataSource _localDataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  CreditCardStatementRepository({
    required ICreditCardStatementLocalDataSource localDataSource,
    required IDatabaseLocalTransaction dbTransaction,
  })  : _localDataSource = localDataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<CreditCardStatementEntity> save(CreditCardStatementEntity entity) async {
    final CreditCardStatementModel model = await _localDataSource.upsert(CreditCardStatementFactory.fromEntity(entity));
    return CreditCardStatementFactory.toEntity(model);
  }

  @override
  Future<void> saveMany(List<CreditCardStatementEntity> statements) async {
    await _dbTransaction.openTransaction((txn) async {
      for (final statement in statements) {
        await _localDataSource.upsert(CreditCardStatementFactory.fromEntity(statement), txn: txn);
      }
    });
  }

  @override
  Future<CreditCardStatementEntity?> findById(String id) async {
    final CreditCardStatementModel? model = await _localDataSource.findById(id);
    return model != null ? CreditCardStatementFactory.toEntity(model) : null;
  }

  @override
  Future<CreditCardStatementEntity?> findFirstAfterDate({required DateTime date, required String idCreditCard}) async {
    final CreditCardStatementModel? model = await _localDataSource.findOne(
      where: '${_localDataSource.tableName}.invoice_closing_date >= ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [date.toIso8601String(), idCreditCard],
    );

    return model != null ? CreditCardStatementFactory.toEntity(model) : null;
  }

  @override
  Future<List<CreditCardStatementEntity>> findAllAfterDate({required DateTime date, required String idCreditCard}) async {
    final List<CreditCardStatementModel> models = await _localDataSource.findAll(
      where: '${_localDataSource.tableName}.invoice_closing_date >= ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [date.toIso8601String(), idCreditCard],
    );

    return models.map((model) => CreditCardStatementFactory.toEntity(model)).toList();
  }
}
