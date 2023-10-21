import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_dates.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardSave implements ICreditCardSave {
  final ICreditCardStatementDates _creditCardStatementDates;
  final ICreditCardRepository _repository;
  final ICreditCardStatementRepository _creditCardStatementRepository;
  final ICreditCardTransactionRepository _creditCardTransactionRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardSave({
    required ICreditCardStatementDates creditCardStatementDates,
    required ICreditCardRepository repository,
    required ICreditCardStatementRepository creditCardStatementRepository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _creditCardStatementDates = creditCardStatementDates,
        _repository = repository,
        _creditCardStatementRepository = creditCardStatementRepository,
        _creditCardTransactionRepository = creditCardTransactionRepository,
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
        final CreditCardEntity? creditCardSaved = await _repository.findById(entity.id, txn: txn);
        if (creditCardSaved == null) throw ValidationException(R.strings.creditCardNotFound);

        if (creditCardSaved.statementClosingDay != entity.statementClosingDay || creditCardSaved.statementDueDay != entity.statementDueDay) {
          //Busca as fatura que estão em aberto
          final List<CreditCardStatementEntity> statements = await _creditCardStatementRepository.findAllAfterDate(date: DateTime.now(), idCreditCard: entity.id, txn: txn);

          final List<CreditCardTransactionEntity> transactions = [];
          for (CreditCardStatementEntity statement in statements) {
            transactions.addAll(statement.transactions);
          }

          //Altera as datas das faturas em aberto
          final List<CreditCardStatementEntity> statementsChanged = _creditCardStatementDates.changeDates(statements: statements, closingDay: entity.statementClosingDay, dueDay: entity.statementDueDay);

          for (CreditCardTransactionEntity transaction in transactions) {
            CreditCardStatementEntity? statement = statementsChanged.firstWhereOrNull((s) => s.statementClosingDate == transaction.date || s.statementClosingDate.isAfter(transaction.date));

            //Gera as datas de fechamento e vencimento da fatura com base na data da transação
            final dates = _creditCardStatementDates.generateDates(closingDay: entity.statementClosingDay, dueDay: entity.statementDueDay, baseDate: transaction.date);

            //Se não existir nenhuma fatura superior a data da transação ou a fatura encontrada for de um mês posterior
            if (statement == null || statement.statementClosingDate.year != dates.closingDate.year || statement.statementClosingDate.month != dates.closingDate.month) {
              //Monta uma nova fatura
              statement = CreditCardStatementEntity(
                id: null,
                createdAt: null,
                deletedAt: null,
                statementClosingDate: dates.closingDate,
                statementDueDate: dates.dueDate,
                idCreditCard: entity.id,
                amountLimit: entity.amountLimit,
                transactions: [],
              );

              statementsChanged.add(statement);

              statementsChanged.sort((a, b) => a.statementClosingDate.compareTo(b.statementClosingDate));
            }

            //Associa a transação a uma fatura
            transaction.idCreditCardStatement = statement.id;

            //Adiciona a transação na fatura
            statement.transactions.add(transaction);
          }

          await _creditCardStatementRepository.saveMany(statementsChanged, txn: txn);
          await _creditCardTransactionRepository.saveMany(transactions, txn: txn);
        }
      }

      return await _repository.save(entity, txn: txn);
    });
  }
}
