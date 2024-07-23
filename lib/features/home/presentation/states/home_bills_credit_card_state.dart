import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_with_bill_entity.dart';

sealed class HomeBillsCreditCardState {
  final List<CreditCardWithBillEntity> creditCardsWithBill;

  const HomeBillsCreditCardState({required this.creditCardsWithBill});

  factory HomeBillsCreditCardState.start() => const StartHomeBillsCreditCardState();

  HomeBillsCreditCardState setLoading() => LoadingHomeBillsCreditCardState(creditCardsWithBill: creditCardsWithBill);

  HomeBillsCreditCardState setCreditCardsWithBill(List<CreditCardWithBillEntity> value) => LoadedHomeBillsCreditCardState(creditCardsWithBill: value);

  HomeBillsCreditCardState setError(String message) => ErrorHomeBillsCreditCardState(message, creditCardsWithBill: creditCardsWithBill);
}

class StartHomeBillsCreditCardState extends HomeBillsCreditCardState {
  const StartHomeBillsCreditCardState() : super(creditCardsWithBill: const []);
}

class LoadingHomeBillsCreditCardState extends HomeBillsCreditCardState {
  const LoadingHomeBillsCreditCardState({required super.creditCardsWithBill});
}

class LoadedHomeBillsCreditCardState extends HomeBillsCreditCardState {
  const LoadedHomeBillsCreditCardState({required super.creditCardsWithBill});
}

class ErrorHomeBillsCreditCardState extends HomeBillsCreditCardState {
  final String message;

  const ErrorHomeBillsCreditCardState(this.message, {required super.creditCardsWithBill});
}
