import 'package:collection/collection.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_find.dart' show ICreditCardBillFind;
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_find.dart';
import 'package:finan_master_app/shared/extensions/date_time_extension.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

typedef BillsFindParams = ({DateTime date, String? idCreditCard});

class CreditCardsDetailsViewModel extends ChangeNotifier {
  final ICreditCardFind _creditCardFind;
  final ICreditCardBillFind _creditCardBillFind;

  late final Command1<void, String?> load;
  late final Command1<List<CreditCardBillEntity>, BillsFindParams> billsFind;

  CreditCardsDetailsViewModel({
    required ICreditCardFind creditCardFind,
    required ICreditCardBillFind creditCardBillFind,
  })  : _creditCardFind = creditCardFind,
        _creditCardBillFind = creditCardBillFind {
    load = Command1(_load);
    billsFind = Command1(_billsFind);
  }

  CreditCardEntity? _creditCardSelected;

  CreditCardEntity? get creditCardSelected => _creditCardSelected;

  void setCreditCardSelected(CreditCardEntity? value) {
    _creditCardSelected = value;

    if (_creditCardSelected == null) {
      billsFind.clearResult();
    } else {
      billsFind.execute((date: DateTime.now().getInitialMonth().subtractMonths(1), idCreditCard: _creditCardSelected!.id));
    }

    notifyListeners();
  }

  List<CreditCardEntity> _creditCards = [];

  List<CreditCardEntity> get creditCards => _creditCards;

  void setCreditCards(List<CreditCardEntity> value) {
    _creditCards = value;
    notifyListeners();
  }

  Future<void> _load(String? idCreditCard) async {
    _creditCards = await _creditCardFind.findAll();

    setCreditCardSelected(_creditCards.firstWhereOrNull((creditCard) => creditCard.id == idCreditCard) ?? _creditCards.firstOrNull);
  }

  Future<List<CreditCardBillEntity>> _billsFind(BillsFindParams params) async => params.idCreditCard == null ? [] : await _creditCardBillFind.findAllAfterDate(date: params.date, idCreditCard: params.idCreditCard!);

  Future<void> refreshCreditCard() async {
    if (_creditCardSelected == null) return;

    setCreditCardSelected(await _creditCardFind.findById(_creditCardSelected!.id));

    final int index = _creditCards.indexWhere((e) => e.id == _creditCardSelected?.id);

    if (index >= 0) setCreditCards(_creditCards..[index] = _creditCardSelected!);
  }
}
