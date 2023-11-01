import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_statement_factory.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_statement_model.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardStatementRepository implements ICreditCardStatementRepository {
  final ICreditCardStatementLocalDataSource _localDataSource;
  final ICreditCardTransactionLocalDataSource _creditCardTransactionLocalDataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  CreditCardStatementRepository({
    required ICreditCardStatementLocalDataSource localDataSource,
    required ICreditCardTransactionLocalDataSource creditCardTransactionLocalDataSource,
    required IDatabaseLocalTransaction dbTransaction,
  })  : _localDataSource = localDataSource,
        _creditCardTransactionLocalDataSource = creditCardTransactionLocalDataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<CreditCardStatementEntity> save(CreditCardStatementEntity entity) async {
    final CreditCardStatementModel model = await _dbTransaction.openTransaction<CreditCardStatementModel>((txn) async {
      final CreditCardStatementModel model = await _localDataSource.upsert(CreditCardStatementFactory.fromEntity(entity), txn: txn);

      for (final transaction in entity.transactions) {
        final CreditCardTransactionModel transactionModel = await _creditCardTransactionLocalDataSource.upsert(CreditCardTransactionFactory.fromEntity(transaction), txn: txn);
        model.transactions.add(transactionModel);
      }

      return model;
    });

    return CreditCardStatementFactory.toEntity(model);
  }

  @override
  Future<void> saveMany(List<CreditCardStatementEntity> statements, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((newTxn) async {
        for (final statement in statements) {
          await _localDataSource.upsert(CreditCardStatementFactory.fromEntity(statement), txn: newTxn);
        }
      });
    } else {
      for (final statement in statements) {
        await _localDataSource.upsert(CreditCardStatementFactory.fromEntity(statement), txn: txn);
      }
    }
  }

  @override
  Future<CreditCardStatementEntity> saveOnlyStatement(CreditCardStatementEntity entity, {ITransactionExecutor? txn}) async {
    final CreditCardStatementModel model = await _localDataSource.upsert(CreditCardStatementFactory.fromEntity(entity), txn: txn);
    return CreditCardStatementFactory.toEntity(model);
  }

  @override
  Future<CreditCardStatementEntity?> findById(String id) async {
    final CreditCardStatementModel? model = await _localDataSource.findById(id);
    return model != null ? CreditCardStatementFactory.toEntity(model) : null;
  }

  @override
  Future<List<CreditCardStatementEntity>> findByIds(List<String> ids) async {
    final List<CreditCardStatementModel> models = await _localDataSource.findAll(where: '${_localDataSource.tableName}.${Model.idColumnName} IN (${ids.map((e) => '?').join(', ')})', whereArgs: ids);
    return models.map((model) => CreditCardStatementFactory.toEntity(model)).toList();
  }

  @override
  Future<CreditCardStatementEntity?> findFirstAfterDate({required DateTime date, required String idCreditCard}) async {
    final CreditCardStatementModel? model = await _localDataSource.findOne(
      where: '${_localDataSource.tableName}.statement_closing_date >= ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [date.toIso8601String(), idCreditCard],
    );

    return model != null ? CreditCardStatementFactory.toEntity(model) : null;
  }

  @override
  Future<List<CreditCardStatementEntity>> findAllAfterDate({required DateTime date, required String idCreditCard, ITransactionExecutor? txn}) async {
    final List<CreditCardStatementModel> models = await _localDataSource.findAll(
      where: '${_localDataSource.tableName}.statement_closing_date >= ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [date.toIso8601String(), idCreditCard],
      txn: txn,
    );

    return models.map((model) => CreditCardStatementFactory.toEntity(model)).toList();
  }

  @override
  Future<CreditCardStatementEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard}) async {
    final CreditCardStatementModel? model = await _localDataSource.findOne(
      where: '${_localDataSource.tableName}.statement_closing_date BETWEEN ? AND ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String(), idCreditCard],
    );

    return model != null ? CreditCardStatementFactory.toEntity(model) : null;
  }
}
