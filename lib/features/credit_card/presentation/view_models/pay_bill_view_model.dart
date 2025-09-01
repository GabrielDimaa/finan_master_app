import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_save.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class PayBillViewModel extends ChangeNotifier {
  final ICreditCardBillSave _creditCardBillSave;

  late final Command0 save;

  PayBillViewModel({required ICreditCardBillSave creditCardBillSave}) : _creditCardBillSave = creditCardBillSave {
    save = Command0(_save);
  }

  double _payValue = 0;

  double get payValue => _payValue;

  void setPayValue(double value) {
    _payValue = value;
    notifyListeners();
  }

  late CreditCardBillEntity _bill;

  CreditCardBillEntity get bill => _bill;

  void load(CreditCardBillEntity bill) {
    _bill = bill;
  }

  Future<void> _save() async {
    _bill = await _creditCardBillSave.payBill(creditCardBill: _bill.clone(), payValue: payValue);
  }
}
