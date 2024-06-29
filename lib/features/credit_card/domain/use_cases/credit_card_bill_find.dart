import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_bill_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_find.dart';

class CreditCardBillFind implements ICreditCardBillFind {
  final ICreditCardBillRepository _repository;

  CreditCardBillFind({required ICreditCardBillRepository repository}) : _repository = repository;

  @override
  Future<CreditCardBillEntity?> findFirstInPeriod({required DateTime startDate, required DateTime endDate, required String idCreditCard}) => _repository.findFirstInPeriod(startDate: startDate, endDate: endDate, idCreditCard: idCreditCard);

  @override
  Future<List<CreditCardBillEntity>> findAllAfterDate({required DateTime date, required String idCreditCard}) => _repository.findAllAfterDate(date: date, idCreditCard: idCreditCard);

  @override
  Future<CreditCardBillEntity?> findById(String id) => _repository.findById(id);
}
