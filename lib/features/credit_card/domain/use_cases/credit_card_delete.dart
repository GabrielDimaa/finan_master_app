import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_delete.dart';

class CreditCardDelete implements ICreditCardDelete {
  final ICreditCardRepository _repository;

  CreditCardDelete({required ICreditCardRepository repository}) : _repository = repository;

  @override
  Future<void> delete(CreditCardEntity entity) => _repository.delete(entity);
}