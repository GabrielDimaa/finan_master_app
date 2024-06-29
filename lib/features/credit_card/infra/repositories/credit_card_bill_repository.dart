import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_bill_factory.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_bill_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_bill_model.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';

class CreditCardBillRepository implements ICreditCardBillRepository {
  final ICreditCardBillLocalDataSource _localDataSource;
  final ICreditCardTransactionLocalDataSource _creditCardTransactionLocalDataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  CreditCardBillRepository({
    required ICreditCardBillLocalDataSource localDataSource,
    required ICreditCardTransactionLocalDataSource creditCardTransactionLocalDataSource,
    required IDatabaseLocalTransaction dbTransaction,
  })  : _localDataSource = localDataSource,
        _creditCardTransactionLocalDataSource = creditCardTransactionLocalDataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<CreditCardBillEntity> save(CreditCardBillEntity entity) async {
    final CreditCardBillModel model = await _dbTransaction.openTransaction<CreditCardBillModel>((txn) async {
      final CreditCardBillModel model = await _localDataSource.upsert(CreditCardBillFactory.fromEntity(entity), txn: txn);

      for (final transaction in entity.transactions) {
        final CreditCardTransactionModel transactionModel = await _creditCardTransactionLocalDataSource.upsert(CreditCardTransactionFactory.fromEntity(transaction), txn: txn);
        model.transactions.add(transactionModel);
      }

      return model;
    });

    return CreditCardBillFactory.toEntity(model);
  }

  @override
  Future<void> saveMany(List<CreditCardBillEntity> bills, {ITransactionExecutor? txn}) async {
    if (txn == null) {
      await _dbTransaction.openTransaction((newTxn) => saveMany(bills, txn: newTxn));
      return;
    }

    for (final bill in bills) {
      await _localDataSource.upsert(CreditCardBillFactory.fromEntity(bill), txn: txn);
    }
  }

  @override
  Future<CreditCardBillEntity> saveOnlyBill(CreditCardBillEntity entity, {ITransactionExecutor? txn}) async {
    final CreditCardBillModel model = await _localDataSource.upsert(CreditCardBillFactory.fromEntity(entity), txn: txn);
    return CreditCardBillFactory.toEntity(model);
  }

  @override
  Future<CreditCardBillEntity?> findById(String id) async {
    final CreditCardBillModel? model = await _localDataSource.findById(id);
    return model != null ? CreditCardBillFactory.toEntity(model) : null;
  }

  @override
  Future<List<CreditCardBillEntity>> findByIds(List<String> ids) async {
    final List<CreditCardBillModel> models = await _localDataSource.findAll(where: '${_localDataSource.tableName}.${Model.idColumnName} IN (${ids.map((e) => '?').join(', ')})', whereArgs: ids);
    return models.map((model) => CreditCardBillFactory.toEntity(model)).toList();
  }

  @override
  Future<CreditCardBillEntity?> findFirstAfterDate({required DateTime date, required String idCreditCard}) async {
    final CreditCardBillModel? model = await _localDataSource.findOne(
      where: '${_localDataSource.tableName}.bill_closing_date > ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [date.toIso8601String(), idCreditCard],
    );

    return model != null ? CreditCardBillFactory.toEntity(model) : null;
  }

  @override
  Future<List<CreditCardBillEntity>> findAllAfterDate({required DateTime date, required String idCreditCard, ITransactionExecutor? txn}) async {
    final List<CreditCardBillModel> models = await _localDataSource.findAll(
      where: '${_localDataSource.tableName}.bill_closing_date >= ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [date.toIso8601String(), idCreditCard],
      txn: txn,
    );

    return models.map((model) => CreditCardBillFactory.toEntity(model)).toList();
  }

  @override
  Future<CreditCardBillEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard}) async {
    final CreditCardBillModel? model = await _localDataSource.findOne(
      where: '${_localDataSource.tableName}.bill_closing_date BETWEEN ? AND ? AND ${_localDataSource.tableName}.id_credit_card = ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String(), idCreditCard],
    );

    return model != null ? CreditCardBillFactory.toEntity(model) : null;
  }
}
