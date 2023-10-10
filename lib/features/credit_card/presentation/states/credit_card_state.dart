import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';

sealed class CreditCardState {
  final CreditCardEntity creditCard;

  const CreditCardState({required this.creditCard});

  factory CreditCardState.start() => StartCreditCardState();

  CreditCardState setCreditCard(CreditCardEntity creditCard) => ChangedCreditCardState(creditCard: creditCard);

  CreditCardState changedCreditCard() => ChangedCreditCardState(creditCard: creditCard);

  CreditCardState setSaving() => SavingCreditCardState(creditCard: creditCard);

  CreditCardState setDeleting() => DeletingCreditCardState(creditCard: creditCard);

  CreditCardState setError(String message) => ErrorCreditCardState(message, creditCard: creditCard);
}

class StartCreditCardState extends CreditCardState {
  StartCreditCardState()
      : super(
          creditCard: CreditCardEntity(
            id: null,
            createdAt: null,
            deletedAt: null,
            description: '',
            amountLimit: 0,
            invoiceClosingDay: 5,
            invoiceDueDay: 10,
            brand: null,
            idAccount: null,
          ),
        );
}

class ChangedCreditCardState extends CreditCardState {
  const ChangedCreditCardState({required super.creditCard});
}

class SavingCreditCardState extends CreditCardState {
  const SavingCreditCardState({required super.creditCard});
}

class DeletingCreditCardState extends CreditCardState {
  const DeletingCreditCardState({required super.creditCard});
}

class ErrorCreditCardState extends CreditCardState {
  final String message;

  const ErrorCreditCardState(this.message, {required super.creditCard});
}
