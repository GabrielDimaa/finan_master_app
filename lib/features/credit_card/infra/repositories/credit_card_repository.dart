import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_factory.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_statement_factory.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_model.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_statement_model.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class CreditCardRepository implements ICreditCardRepository {
  final ICreditCardLocalDataSource _creditCardDataSource;
  final ICreditCardTransactionLocalDataSource _creditCardTransactionDataSource;
  final ICreditCardStatementLocalDataSource _creditCardStatementDataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  CreditCardRepository({
    required ICreditCardLocalDataSource creditCardDataSource,
    required ICreditCardTransactionLocalDataSource creditCardTransactionDataSource,
    required ICreditCardStatementLocalDataSource creditCardStatementDataSource,
    required IDatabaseLocalTransaction dbTransaction,
  })  : _creditCardDataSource = creditCardDataSource,
        _creditCardTransactionDataSource = creditCardTransactionDataSource,
        _creditCardStatementDataSource = creditCardStatementDataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity) async {
    final CreditCardModel creditCard = await _creditCardDataSource.upsert(CreditCardFactory.fromEntity(entity));
    return CreditCardFactory.toEntity(creditCard);
  }

  @override
  Future<void> delete(CreditCardEntity entity) => _creditCardDataSource.delete(CreditCardFactory.fromEntity(entity));

  @override
  Future<List<CreditCardEntity>> findAll() async {
    final List<CreditCardModel> result = await _creditCardDataSource.findAll();
    return result.map((e) => CreditCardFactory.toEntity(e)).toList();
  }

  @override
  Future<CreditCardEntity?> findById(String id) async {
    final CreditCardModel? model = await _creditCardDataSource.findById(id);
    return model != null ? CreditCardFactory.toEntity(model) : null;
  }

  @override
  Future<CreditCardTransactionEntity> saveTransaction(CreditCardTransactionEntity entity) async {
    final CreditCardTransactionModel transaction = await _creditCardTransactionDataSource.upsert(CreditCardTransactionFactory.fromEntity(entity));
    return CreditCardTransactionFactory.toEntity(transaction);
  }

  @override
  Future<CreditCardTransactionEntity> saveTransactionWithNewStatement({required CreditCardTransactionEntity entity, required CreditCardStatementEntity statement}) async {
    final CreditCardTransactionModel model = await _dbTransaction.openTransaction<CreditCardTransactionModel>((txn) async {
      await _creditCardStatementDataSource.upsert(CreditCardStatementFactory.fromEntity(statement), txn: txn);
      return await _creditCardTransactionDataSource.upsert(CreditCardTransactionFactory.fromEntity(entity), txn: txn);
    });

    return CreditCardTransactionFactory.toEntity(model);
  }

  @override
  Future<CreditCardStatementEntity?> findStatementById(String id) async {
    final CreditCardStatementModel? model = await _creditCardStatementDataSource.findById(id);
    return model != null ? CreditCardStatementFactory.toEntity(model) : null;
  }

  @override
  Future<CreditCardStatementEntity?> findStatementByDate(DateTime date) async {
    final CreditCardStatementModel? model = await _creditCardStatementDataSource.findOne(where: 'invoice_closing_date >= ?', whereArgs: [date.toIso8601String()]);
    return model != null ? CreditCardStatementFactory.toEntity(model) : null;
  }
}
