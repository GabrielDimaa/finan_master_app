import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_find.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class CreditCardBillsViewModel extends ChangeNotifier {
  final ICreditCardBillFind _creditCardBillFind;

  late final Command0<List<CreditCardBillEntity>> findByPeriod;

  CreditCardBillsViewModel({required ICreditCardBillFind creditCardBillFind}) : _creditCardBillFind = creditCardBillFind {
    findByPeriod = Command0(_findByPeriod);
  }

  late CreditCardEntity _creditCard;

  CreditCardEntity get creditCard => _creditCard;

  late DateTime _startDate;

  DateTime get startDate => _startDate;

  void setStartDate(DateTime value) => _startDate = value;

  late DateTime _endDate;

  DateTime get endDate => _endDate;

  void setEndDate(DateTime value) => _endDate = value;

  void init(CreditCardEntity creditCard) {
    _creditCard = creditCard;
    final DateTime now = DateTime.now();

    _startDate = DateTime(now.subtractMonths(2).year, now.subtractMonths(2).month, now.day).getInitialMonth();
    _endDate = DateTime(now.addMonths(10).year, now.addMonths(10).month, now.day).getFinalMonth();
  }

  Future<List<CreditCardBillEntity>> _findByPeriod() => _creditCardBillFind.findByPeriod(startDate: startDate, endDate: endDate, idCreditCard: _creditCard.id);
}
