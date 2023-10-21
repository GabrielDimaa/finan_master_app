import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_statement_factory.dart';
import 'package:finan_master_app/features/credit_card/helpers/factories/credit_card_transaction_factory.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_statement_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/data_sources/i_credit_card_transaction_local_data_source.dart';
import 'package:finan_master_app/features/credit_card/infra/models/credit_card_transaction_model.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_transaction.dart';

class CreditCardTransactionRepository implements ICreditCardTransactionRepository {
  final ICreditCardTransactionLocalDataSource _creditCardTransactionDataSource;
  final ICreditCardStatementLocalDataSource _creditCardStatementDataSource;
  final IDatabaseLocalTransaction _dbTransaction;

  CreditCardTransactionRepository({
    required ICreditCardTransactionLocalDataSource creditCardTransactionDataSource,
    required ICreditCardStatementLocalDataSource creditCardStatementDataSource,
    required IDatabaseLocalTransaction dbTransaction,
  })  : _creditCardTransactionDataSource = creditCardTransactionDataSource,
        _creditCardStatementDataSource = creditCardStatementDataSource,
        _dbTransaction = dbTransaction;

  @override
  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity) async {
    final CreditCardTransactionModel transaction = await _creditCardTransactionDataSource.upsert(CreditCardTransactionFactory.fromEntity(entity));
    return CreditCardTransactionFactory.toEntity(transaction);
  }
}
