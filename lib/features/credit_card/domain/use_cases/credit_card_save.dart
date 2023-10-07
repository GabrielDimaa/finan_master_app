import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/repositories/i_credit_card_repository.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_save.dart';

class CreditCardSave implements ICreditCardSave {
  final ICreditCardRepository _repository;

  CreditCardSave({required ICreditCardRepository repository}) : _repository = repository;

  @override
  Future<CreditCardEntity> save(CreditCardEntity entity) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
