import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_statement_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardTransactionSave implements ICreditCardTransactionSave {
  final ICreditCardRepository _repository;

  CreditCardTransactionSave({required ICreditCardRepository repository}) : _repository = repository;

  @override
  Future<CreditCardTransactionEntity> save(CreditCardTransactionEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.amount <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.idCategory == null) throw ValidationException(R.strings.uninformedCategory);
    if (entity.idCreditCard == null) throw ValidationException(R.strings.uninformedCreditCard);

    final CreditCardEntity? creditCard = await _repository.findById(entity.idCreditCard!);
    if (creditCard == null) throw ValidationException(R.strings.creditCardNotFound);

    //Se a entidade já pertencer a uma fatura.
    if (!entity.isNew && entity.idCreditCardStatement != null) {
      final CreditCardStatementEntity? statement = await _repository.findStatementById(entity.idCreditCardStatement!);
      if (statement == null) throw ValidationException(R.strings.creditCardStatementNotFound);

      //Não é possível editar uma transação de uma fatura fechada.
      if (statement.invoiceClosingDate.isBefore(DateTime.now())) throw ValidationException(R.strings.notPossibleEditTransactionStatementClosed);
    }

    CreditCardStatementEntity? statement = await _repository.findStatementByDate(date: entity.date, idCreditCard: creditCard.id);

    //Se não encontrar a fatura, significa que não foi criada ainda
    if (statement == null) {
      //Monta a fatura.
      final dates = calculateClosingDateAndDueDate(invoiceClosingDay: creditCard.invoiceClosingDay, invoiceDueDay: creditCard.invoiceDueDay, baseDate: entity.date);

      statement = CreditCardStatementEntity(
        id: null,
        createdAt: null,
        deletedAt: null,
        invoiceClosingDate: dates.invoiceClosingDate,
        invoiceDueDate: dates.invoiceClosingDate,
        idCreditCard: creditCard.id,
        statementAmount: 0,
        amountLimit: creditCard.amountLimit,
      );
    }

    //Se a fatura já estiver fechada.
    if (statement.invoiceClosingDate.isBefore(DateTime.now())) throw ValidationException(R.strings.statementClosedInDateTransaction);

    //Se o valor da transação for superior ao limite disponível na fatura.
    if (entity.amount > statement.amountLimit) throw ValidationException(R.strings.transactionAmountExceedLimitStatement);

    //Associa a transação a uma fatura.
    entity.idCreditCardStatement = statement.id;

    //Se for uma nova fatura, salva a transação com a fatura.
    if (statement.isNew) {
      return await _repository.saveTransactionWithNewStatement(entity: entity, statement: statement);
    } else {
      return await _repository.saveTransaction(entity);
    }
  }

  ({DateTime invoiceClosingDate, DateTime invoiceDueDate}) calculateClosingDateAndDueDate({required int invoiceClosingDay, required int invoiceDueDay, required DateTime baseDate}) {
    DateTime invoiceClosingDate = DateTime(baseDate.year, baseDate.month, invoiceClosingDay, 23, 59, 59, 999);
    DateTime invoiceDueDate = DateTime(baseDate.year, baseDate.month, invoiceDueDay, 23, 59, 59, 999);

    if (invoiceClosingDate.isBefore(baseDate)) {
      invoiceClosingDate = invoiceClosingDate.addMonth(1);
      invoiceDueDate = invoiceDueDate.addMonth(1);
    }

    if (invoiceClosingDay > invoiceDueDay) {
      invoiceDueDate = invoiceDueDate.addMonth(1);
    }

    return (invoiceClosingDate: invoiceClosingDate, invoiceDueDate: invoiceDueDate);
  }
}
