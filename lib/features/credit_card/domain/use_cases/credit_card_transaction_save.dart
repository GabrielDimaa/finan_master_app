import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_statement_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_statement_dates.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardTransactionSave implements ICreditCardTransactionSave {
  final ICreditCardStatementDates _creditCardStatementDates;
  final ICreditCardRepository _repository;
  final ICreditCardStatementRepository _creditCardStatementRepository;
  final ICreditCardTransactionRepository _creditCardTransactionRepository;

  CreditCardTransactionSave({
    required ICreditCardStatementDates creditCardStatementDates,
    required ICreditCardRepository repository,
    required ICreditCardStatementRepository creditCardStatementRepository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
  })  : _creditCardStatementDates = creditCardStatementDates,
        _repository = repository,
        _creditCardStatementRepository = creditCardStatementRepository,
        _creditCardTransactionRepository = creditCardTransactionRepository;

  @override
  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.amount <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.idCategory == null) throw ValidationException(R.strings.uninformedCategory);
    if (entity.idCreditCard == null) throw ValidationException(R.strings.uninformedCreditCard);

    final CreditCardEntity? creditCard = await _repository.findById(entity.idCreditCard!);
    if (creditCard == null) throw ValidationException(R.strings.creditCardNotFound);

    //Se a entidade já pertencer a uma fatura
    if (!entity.isNew && entity.idCreditCardStatement != null) {
      final CreditCardStatementEntity? statement = await _creditCardStatementRepository.findById(entity.idCreditCardStatement!);
      if (statement == null) throw ValidationException(R.strings.creditCardStatementNotFound);

      //Não é possível editar uma transação de uma fatura paga
      if (statement.paid) throw ValidationException(R.strings.notPossibleEditTransactionCreditCardPaid);
    }

    CreditCardStatementEntity? statement = await _creditCardStatementRepository.findFirstAfterDate(date: entity.date, idCreditCard: creditCard.id);

    //Gera as datas de fechamento e vencimento da fatura com base na data da transação
    final dates = _creditCardStatementDates.generateDates(closingDay: creditCard.statementClosingDay, dueDay: creditCard.statementDueDay, baseDate: entity.date);

    //Se não existir nenhuma fatura superior a data da transação ou a fatura encontrada for de um mês posterior
    if (statement == null || statement.statementClosingDate.year != dates.closingDate.year || statement.statementClosingDate.month != dates.closingDate.month) {
      //Monta uma nova fatura
      statement = CreditCardStatementEntity(
        id: null,
        createdAt: null,
        deletedAt: null,
        statementClosingDate: dates.closingDate,
        statementDueDate: dates.dueDate,
        idCreditCard: creditCard.id,
        amountLimit: creditCard.amountLimit,
        transactions: [],
        paid: false,
      );
    }

    //Se a fatura já estiver fechada
    if (statement.statementClosingDate.isBefore(DateTime.now())) throw ValidationException(R.strings.statementClosedInDateTransaction);

    //Associa a transação a uma fatura
    entity.idCreditCardStatement = statement.id;

    //Adiciona a transação na fatura
    statement.transactions.add(entity);

    //Se for uma nova fatura, salva a transação com a fatura
    if (statement.isNew) {
      final statementResult = await _creditCardStatementRepository.save(statement);
      return statementResult.transactions.firstWhere((e) => e.id == entity.id);
    } else {
      return await _creditCardTransactionRepository.save(entity);
    }
  }
}
