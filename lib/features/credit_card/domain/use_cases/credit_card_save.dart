import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_dates.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardSave implements ICreditCardSave {
  final ICreditCardStatementDates _creditCardStatementDates;
  final ICreditCardRepository _repository;
  final ICreditCardStatementRepository _creditCardStatementRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardSave({
    required ICreditCardStatementDates creditCardStatementDates,
    required ICreditCardRepository repository,
    required ICreditCardStatementRepository creditCardStatementRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _creditCardStatementDates = creditCardStatementDates,
        _repository = repository,
        _creditCardStatementRepository = creditCardStatementRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.amountLimit <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.statementClosingDay <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.statementDueDay <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.statementClosingDay > 31 || entity.statementDueDay > 31) throw ValidationException('${R.strings.lessThan} 31');
    if (entity.brand == null) return throw ValidationException(R.strings.uninformedCardBrand);
    if (entity.idAccount == null) return throw ValidationException(R.strings.uninformedAccount);

    return _localDBTransactionRepository.openTransaction<CreditCardEntity>((txn) async {
      if (!entity.isNew) {
        //Busca as fatura que estão em aberto
        final List<CreditCardStatementEntity> statements = await _creditCardStatementRepository.findAllAfterDate(date: DateTime.now(), idCreditCard: entity.id, txn: txn);

        //Altera as datas das faturas em aberto
        final List<CreditCardStatementEntity> statementsChanged = _creditCardStatementDates.changeDates(statements: statements, closingDay: entity.statementClosingDay, dueDay: entity.statementDueDay);

        await _creditCardStatementRepository.saveMany(statementsChanged, txn: txn);
      }

      return await _repository.save(entity, txn: txn);
    });
  }
}
