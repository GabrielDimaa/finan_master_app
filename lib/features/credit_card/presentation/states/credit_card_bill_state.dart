import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';

sealed class CreditCardBillState {
  final CreditCardBillEntity? creditCardBill;

  const CreditCardBillState({required this.creditCardBill});

  factory CreditCardBillState.start() => const StartCreditCardBillState();

  CreditCardBillState setBill(CreditCardBillEntity? bill) => ChangedCreditCardBillState(creditCardBill: bill);

  CreditCardBillState changedBill() => ChangedCreditCardBillState(creditCardBill: creditCardBill);

  CreditCardBillState setLoading() => const LoadingCreditCardBillState();

  CreditCardBillState setSaving() => SavingCreditCardBillState(creditCardBill: creditCardBill);

  CreditCardBillState setError(String message) => ErrorCreditCardBillState(message, creditCardBill: creditCardBill);
}

class StartCreditCardBillState extends CreditCardBillState {
  const StartCreditCardBillState() : super(creditCardBill: null);
}

class ChangedCreditCardBillState extends CreditCardBillState {
  const ChangedCreditCardBillState({required super.creditCardBill});
}

class LoadingCreditCardBillState extends CreditCardBillState {
  const LoadingCreditCardBillState() : super(creditCardBill: null);
}

class SavingCreditCardBillState extends CreditCardBillState {
  const SavingCreditCardBillState({required super.creditCardBill});
}

class ErrorCreditCardBillState extends CreditCardBillState {
  final String message;

  const ErrorCreditCardBillState(this.message, {required super.creditCardBill});
}
