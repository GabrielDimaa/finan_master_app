import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';

abstract interface class ICreditCardDelete {
  Future<void> delete(CreditCardEntity entity);
}
