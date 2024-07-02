import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';

sealed class CreditCardsState {
  final List<CreditCardEntity> creditCards;

  const CreditCardsState(this.creditCards);

  factory CreditCardsState.start() => const StartCreditCardsState([]);

  CreditCardsState setCreditCards(List<CreditCardEntity> creditCards) => creditCards.isEmpty ? const EmptyCreditCardsState([]) : ListCreditCardsState(creditCards);

  CreditCardsState setLoading() => LoadingCreditCardsState(creditCards);

  CreditCardsState setError(String message) => ErrorCreditCardsState(message);
}

class StartCreditCardsState extends CreditCardsState {
  const StartCreditCardsState(super.creditCards);
}

class ListCreditCardsState extends CreditCardsState {
  const ListCreditCardsState(super.creditCards);
}

class EmptyCreditCardsState extends CreditCardsState {
  const EmptyCreditCardsState(super.creditCards);
}

class LoadingCreditCardsState extends CreditCardsState {
  const LoadingCreditCardsState(super.creditCards);
}

class ErrorCreditCardsState extends CreditCardsState {
  final String message;

  const ErrorCreditCardsState(this.message) : super(const []);
}
