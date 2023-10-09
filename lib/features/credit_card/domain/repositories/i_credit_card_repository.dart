import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';

abstract interface class ICreditCardRepository {
  Future<CreditCardEntity> save(CreditCardEntity entity);

  Future<void> delete(CreditCardEntity entity);

  Future<List<CreditCardEntity>> findAll();
}
