import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardTransactionDelete implements ICreditCardTransactionDelete {
  final ICreditCardTransactionRepository _repository;
  final ICreditCardStatementRepository _creditCardStatementRepository;

  CreditCardTransactionDelete({
    required ICreditCardTransactionRepository repository,
    required ICreditCardStatementRepository creditCardStatementRepository,
  })  : _repository = repository,
        _creditCardStatementRepository = creditCardStatementRepository;

  @override
  Future<void> delete(CreditCardTransactionEntity entity) async {
    final CreditCardStatementEntity? statement = await _creditCardStatementRepository.findById(entity.idCreditCardStatement!);
    if (statement == null) throw ValidationException(R.strings.creditCardStatementNotFound);

    //Não é possível excluir uma transação de uma fatura paga
    if (statement.paid) throw ValidationException(R.strings.notPossibleDeleteTransactionCreditCardPaid);

    await _repository.delete(entity);
  }

  @override
  Future<void> deleteMany(List<CreditCardTransactionEntity> entities) async {
    final List<String> idsStatements = [];

    for (final CreditCardTransactionEntity entity in entities) {
      if (entity.idCreditCardStatement != null && !idsStatements.any((id) => entity.idCreditCardStatement == id)) {
        idsStatements.add(entity.idCreditCardStatement!);
      }
    }

    final List<CreditCardStatementEntity> statements = await _creditCardStatementRepository.findByIds(idsStatements);
    if (statements.any((statement) => statement.paid)) throw ValidationException(R.strings.notPossibleDeleteTransactionCreditCardPaid);

    await _repository.deleteMany(entities);
  }
}
