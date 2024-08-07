import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_with_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';

class CreditCardFind implements ICreditCardFind {
  final ICreditCardRepository _repository;

  CreditCardFind({required ICreditCardRepository repository}) : _repository = repository;

  @override
  Future<List<CreditCardEntity>> findAll() => _repository.findAll();

  @override
  Future<CreditCardEntity?> findById(String id) => _repository.findById(id);

  @override
  Future<List<CreditCardWithBillEntity>> findCreditCardsWithBill() => _repository.findCreditCardsWithBill();
}
