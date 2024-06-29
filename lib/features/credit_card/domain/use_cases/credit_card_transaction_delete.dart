import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_transaction_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/shared/exceptions/exceptions.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class CreditCardTransactionDelete implements ICreditCardTransactionDelete {
  final ICreditCardTransactionRepository _repository;
  final ICreditCardBillRepository _creditCardBillRepository;

  CreditCardTransactionDelete({
    required ICreditCardTransactionRepository repository,
    required ICreditCardBillRepository creditCardBillRepository,
  })  : _repository = repository,
        _creditCardBillRepository = creditCardBillRepository;

  @override
  Future<void> delete(CreditCardTransactionEntity entity) async {
    final CreditCardBillEntity? bill = await _creditCardBillRepository.findById(entity.idCreditCardBill!);
    if (bill == null) throw ValidationException(R.strings.creditCardBillNotFound);

    //Não é possível excluir uma transação de uma fatura paga
    if (bill.paid) throw ValidationException(R.strings.notPossibleDeleteTransactionCreditCardPaid);

    await _repository.delete(entity);
  }

  @override
  Future<void> deleteMany(List<CreditCardTransactionEntity> entities) async {
    final List<String> idsBills = [];

    for (final CreditCardTransactionEntity entity in entities) {
      if (entity.idCreditCardBill != null && !idsBills.any((id) => entity.idCreditCardBill == id)) {
        idsBills.add(entity.idCreditCardBill!);
      }
    }

    final List<CreditCardBillEntity> bills = await _creditCardBillRepository.findByIds(idsBills);
    if (bills.any((bill) => bill.paid)) throw ValidationException(R.strings.notPossibleDeleteTransactionCreditCardPaid);

    await _repository.deleteMany(entities);
  }
}
