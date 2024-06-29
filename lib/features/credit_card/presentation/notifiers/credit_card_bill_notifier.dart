import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_save.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_card_bill_state.dart';
import 'package:flutter/foundation.dart';

class CreditCardBillNotifier extends ValueNotifier<CreditCardBillState> {
  final ICreditCardBillFind _creditCardBillFind;
  final ICreditCardBillSave _creditCardBillSave;
  final ICreditCardTransactionDelete _creditCardTransactionDelete;

  CreditCardBillNotifier({
    required ICreditCardBillFind creditCardBillFind,
    required ICreditCardBillSave creditCardBillSave,
    required ICreditCardTransactionDelete creditCardTransactionDelete,
  })  : _creditCardBillFind = creditCardBillFind,
        _creditCardBillSave = creditCardBillSave,
        _creditCardTransactionDelete = creditCardTransactionDelete,
        super(CreditCardBillState.start());

  bool get isLoading => value is SavingCreditCardBillState;

  CreditCardBillEntity? get creditCardBill => value.creditCardBill;

  void setBill(CreditCardBillEntity? bill) => value = value.setBill(bill);

  Future<void> findById(String id) async {
    try {
      value = value.setLoading();
      final CreditCardBillEntity? bill = await _creditCardBillFind.findById(id);
      value = value.setBill(bill);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> payBill(double payValue) async {
    try {
      value = value.setSaving();
      final CreditCardBillEntity bill = await _creditCardBillSave.payBill(creditCardBill: creditCardBill!, payValue: payValue);
      value = value.setBill(bill);
    } catch (e) {
      value = value.setError(e.toString());
    }
  }

  Future<void> deleteTransactions(List<CreditCardTransactionEntity> transactions) => _creditCardTransactionDelete.deleteMany(transactions);
}
