import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_delete.dart';

class CreditCardDelete implements ICreditCardDelete {
  final ICreditCardRepository _repository;
  final IAdAccess _adAccess;

  CreditCardDelete({required ICreditCardRepository repository, required IAdAccess adAccess}) : _repository = repository, _adAccess = adAccess;

  @override
  Future<void> delete(CreditCardEntity entity) => _repository.delete(entity).then((_) => _adAccess.consumeUse());
}