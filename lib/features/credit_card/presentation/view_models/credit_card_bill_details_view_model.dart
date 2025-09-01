import 'package:finan_master_app/features/category/domain/entities/category_entity.dart';
import 'package:finan_master_app/features/category/domain/use_cases/i_category_find.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_bill_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_transaction_entity.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_bill_find.dart';
import 'package:finan_master_app/features/credit_card/domain/use_cases/i_credit_card_transaction_delete.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/foundation.dart';

class CreditCardBillDetailsViewModel extends ChangeNotifier {
  final ICreditCardBillFind _creditCardBillFind;
  final ICategoryFind _categoryFind;

  late final Command1<void, CreditCardBillEntity> load;
  late final Command0<void> refreshBill;
  late final Command1<void, List<CreditCardTransactionEntity>> deleteTransactions;
  late final Command1<void, double> payBill;

  CreditCardBillDetailsViewModel({
    required ICreditCardBillFind creditCardBillFind,
    required ICreditCardTransactionDelete creditCardTransactionDelete,
    required ICategoryFind categoryFind,
  })  : _creditCardBillFind = creditCardBillFind,
        _categoryFind = categoryFind {
    load = Command1(_load);
    refreshBill = Command0(_refreshBill);
    deleteTransactions = Command1(creditCardTransactionDelete.deleteMany);
  }

  late CreditCardBillEntity _bill;
  List<CategoryEntity> _categories = [];

  CreditCardBillEntity get bill => _bill;

  List<CategoryEntity> get categories => _categories;

  Future<void> _load(CreditCardBillEntity bill) async {
    _bill = bill;
    _categories = await _categoryFind.findAll(deleted: true);
  }

  Future<void> _refreshBill() async {
    _bill = await _creditCardBillFind.findById(_bill.id) ?? (throw Exception(R.strings.billNotFound));
    notifyListeners();
  }
}
