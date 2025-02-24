import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_dates.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_save.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardTransactionSave implements ICreditCardTransactionSave {
  final ICreditCardBillDates _creditCardBillDates;
  final ICreditCardRepository _repository;
  final ICreditCardBillRepository _creditCardBillRepository;
  final ICreditCardTransactionRepository _creditCardTransactionRepository;

  CreditCardTransactionSave({
    required ICreditCardBillDates creditCardBillDates,
    required ICreditCardRepository repository,
    required ICreditCardBillRepository creditCardBillRepository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
  })  : _creditCardBillDates = creditCardBillDates,
        _repository = repository,
        _creditCardBillRepository = creditCardBillRepository,
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
    if (!entity.isNew && entity.idCreditCardBill != null) {
      final CreditCardBillEntity? bill = await _creditCardBillRepository.findById(entity.idCreditCardBill!);
      if (bill == null) throw ValidationException(R.strings.creditCardBillNotFound);
    }

    CreditCardBillEntity? bill = await _creditCardBillRepository.findFirstAfterDate(date: entity.date, idCreditCard: creditCard.id);

    //Gera as datas de fechamento e vencimento da fatura com base na data da transação
    final dates = _creditCardBillDates.generateDates(closingDay: creditCard.billClosingDay, dueDay: creditCard.billDueDay, baseDate: entity.date);

    //Se não existir nenhuma fatura superior a data da transação ou a fatura encontrada for de um mês posterior
    if (bill == null || bill.billClosingDate.year != dates.closingDate.year || bill.billClosingDate.month != dates.closingDate.month) {
      //Monta uma nova fatura
      bill = CreditCardBillEntity(
        id: null,
        createdAt: null,
        deletedAt: null,
        billClosingDate: dates.closingDate,
        billDueDate: dates.dueDate,
        idCreditCard: creditCard.id,
        transactions: [],
      );
    }

    //Se a fatura já estiver fechada
    if (bill.billClosingDate.isBefore(DateTime.now())) throw ValidationException(R.strings.billClosedInDateTransaction);

    //Associa a transação a uma fatura
    entity.idCreditCardBill = bill.id;

    //Adiciona a transação na fatura
    bill.transactions.add(entity);

    //Se for uma nova fatura, salva a transação com a fatura
    if (bill.isNew) {
      final billResult = await _creditCardBillRepository.save(bill);
      return billResult.transactions.firstWhere((e) => e.id == entity.id);
    } else {
      return await _creditCardTransactionRepository.save(entity);
    }
  }
}
