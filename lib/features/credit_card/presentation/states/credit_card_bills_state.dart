import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';

sealed class CreditCardBillsState {
  final List<CreditCardBillEntity> bills;

  const CreditCardBillsState({required this.bills});

  factory CreditCardBillsState.start() => const StartCreditCardBillsState();

  CreditCardBillsState setBills(List<CreditCardBillEntity> bills) => ListCreditCardBillsState(bills: bills);

  CreditCardBillsState setLoading() => LoadingCreditCardBillsState(bills: bills);

  CreditCardBillsState setError(String message) => ErrorCreditCardBillsState(message, bills: bills);
}

class StartCreditCardBillsState extends CreditCardBillsState {
  const StartCreditCardBillsState() : super(bills: const []);
}

class LoadingCreditCardBillsState extends CreditCardBillsState {
  const LoadingCreditCardBillsState({required super.bills});
}

class ListCreditCardBillsState extends CreditCardBillsState {
  const ListCreditCardBillsState({required super.bills});
}

class ErrorCreditCardBillsState extends CreditCardBillsState {
  final String message;

  const ErrorCreditCardBillsState(this.message, {required super.bills});
}
