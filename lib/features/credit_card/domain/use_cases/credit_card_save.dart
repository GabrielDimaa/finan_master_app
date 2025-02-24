import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_dates.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';
import 'package:finan_master_app/shared/domain/repositories/i_local_db_transaction_repository.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardSave implements ICreditCardSave {
  final ICreditCardBillDates _creditCardBillDates;
  final ICreditCardRepository _repository;
  final ICreditCardBillRepository _creditCardBillRepository;
  final ICreditCardTransactionRepository _creditCardTransactionRepository;
  final ILocalDBTransactionRepository _localDBTransactionRepository;

  CreditCardSave({
    required ICreditCardBillDates creditCardBillDates,
    required ICreditCardRepository repository,
    required ICreditCardBillRepository creditCardBillRepository,
    required ICreditCardTransactionRepository creditCardTransactionRepository,
    required ILocalDBTransactionRepository localDBTransactionRepository,
  })  : _creditCardBillDates = creditCardBillDates,
        _repository = repository,
        _creditCardBillRepository = creditCardBillRepository,
        _creditCardTransactionRepository = creditCardTransactionRepository,
        _localDBTransactionRepository = localDBTransactionRepository;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity) async {
    if (entity.description.trim().isEmpty) throw ValidationException(R.strings.uninformedDescription);
    if (entity.amountLimit <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.billClosingDay <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.billDueDay <= 0) throw ValidationException(R.strings.greaterThanZero);
    if (entity.billClosingDay > 31 || entity.billDueDay > 31) throw ValidationException('${R.strings.lessThan} 31');
    if (entity.brand == null) return throw ValidationException(R.strings.uninformedCardBrand);
    if (entity.idAccount == null) return throw ValidationException(R.strings.uninformedAccount);

    return _localDBTransactionRepository.openTransaction<CreditCardEntity>((txn) async {
      if (!entity.isNew) {
        final CreditCardEntity? creditCardSaved = await _repository.findById(entity.id, txn: txn);
        if (creditCardSaved == null) throw ValidationException(R.strings.creditCardNotFound);

        if (creditCardSaved.billClosingDay != entity.billClosingDay || creditCardSaved.billDueDay != entity.billDueDay) {
          //Busca as fatura que estão em aberto
          final List<CreditCardBillEntity> bills = await _creditCardBillRepository.findAllAfterDate(date: DateTime.now(), idCreditCard: entity.id, txn: txn);

          final List<CreditCardTransactionEntity> transactions = [];
          for (CreditCardBillEntity bill in bills) {
            transactions.addAll(bill.transactions);
          }

          //Altera as datas das faturas em aberto
          final List<CreditCardBillEntity> billsChanged = _creditCardBillDates.changeDates(bills: bills, closingDay: entity.billClosingDay, dueDay: entity.billDueDay);

          for (CreditCardTransactionEntity transaction in transactions) {
            CreditCardBillEntity? bill = billsChanged.firstWhereOrNull((s) => s.billClosingDate == transaction.date || s.billClosingDate.isAfter(transaction.date));

            //Gera as datas de fechamento e vencimento da fatura com base na data da transação
            final dates = _creditCardBillDates.generateDates(closingDay: entity.billClosingDay, dueDay: entity.billDueDay, baseDate: transaction.date);

            //Se não existir nenhuma fatura superior a data da transação ou a fatura encontrada for de um mês posterior
            if (bill == null || bill.billClosingDate.year != dates.closingDate.year || bill.billClosingDate.month != dates.closingDate.month) {
              //Monta uma nova fatura
              bill = CreditCardBillEntity(
                id: null,
                createdAt: null,
                deletedAt: null,
                billClosingDate: dates.closingDate,
                billDueDate: dates.dueDate,
                idCreditCard: entity.id,
                transactions: [],
              );

              billsChanged.add(bill);

              billsChanged.sort((a, b) => a.billClosingDate.compareTo(b.billClosingDate));
            }

            //Associa a transação a uma fatura
            transaction.idCreditCardBill = bill.id;

            //Adiciona a transação na fatura
            bill.transactions.add(transaction);
          }

          await _creditCardBillRepository.saveMany(billsChanged, txn: txn);
          await _creditCardTransactionRepository.saveMany(transactions, txn: txn);
        }
      }

      return await _repository.save(entity, txn: txn);
    });
  }
}
